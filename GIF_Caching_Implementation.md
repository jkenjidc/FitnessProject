# Exercise GIF Caching Implementation

## Overview
Implementation for caching GIF data from ExerciseDB API that returns streamed GIF images directly (Content-Type: image/gif).

## Step 1: Image Data Caching System

```swift
// File: ExerciseImageCache.swift
import Foundation
import UIKit

class ExerciseImageCache {
    static let shared = ExerciseImageCache()
    private let imageCache = NSCache<NSString, NSData>()
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    
    init() {
        // Create cache directory
        let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        cacheDirectory = documentsPath.appendingPathComponent("ExerciseGifs")
        
        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
        
        // Configure memory cache
        imageCache.countLimit = 50 // Limit to 50 GIFs in memory
        imageCache.totalCostLimit = 100 * 1024 * 1024 // 100MB memory limit
    }
    
    func cacheGif(_ data: Data, for exerciseId: String) {
        // Cache in memory
        imageCache.setObject(data as NSData, forKey: exerciseId as NSString, cost: data.count)
        
        // Cache to disk
        let fileURL = cacheDirectory.appendingPathComponent("\(exerciseId).gif")
        try? data.write(to: fileURL)
    }
    
    func getCachedGif(for exerciseId: String) -> Data? {
        // Try memory first
        if let cachedData = imageCache.object(forKey: exerciseId as NSString) {
            return cachedData as Data
        }
        
        // Try disk cache
        let fileURL = cacheDirectory.appendingPathComponent("\(exerciseId).gif")
        if let diskData = try? Data(contentsOf: fileURL) {
            // Put back in memory cache
            imageCache.setObject(diskData as NSData, forKey: exerciseId as NSString, cost: diskData.count)
            return diskData
        }
        
        return nil
    }
    
    func getCachedGifURL(for exerciseId: String) -> URL? {
        let fileURL = cacheDirectory.appendingPathComponent("\(exerciseId).gif")
        return fileManager.fileExists(atPath: fileURL.path) ? fileURL : nil
    }
    
    func isCached(exerciseId: String) -> Bool {
        return getCachedGif(for: exerciseId) != nil
    }
    
    func clearCache() {
        imageCache.removeAllObjects()
        try? fileManager.removeItem(at: cacheDirectory)
        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
    }
}
```

## Step 2: AsyncSemaphore for Concurrency Control

```swift
// File: AsyncSemaphore.swift
import Foundation

actor AsyncSemaphore {
    private var value: Int
    private var waiters: [CheckedContinuation<Void, Never>] = []
    
    init(value: Int) {
        self.value = value
    }
    
    func wait() async {
        if value > 0 {
            value -= 1
            return
        }
        
        await withCheckedContinuation { continuation in
            waiters.append(continuation)
        }
    }
    
    func signal() {
        if waiters.isEmpty {
            value += 1
        } else {
            let waiter = waiters.removeFirst()
            waiter.resume()
        }
    }
}
```

## Step 3: Update ExerciseV2 Model

```swift
// Add to ExerciseV2.swift
extension ExerciseV2 {
    init(from dto: ExerciseV2DTO, hasGifData: Bool = false) {
        self.id = dto.id
        self.name = dto.name
        self.bodyPart = dto.bodyPart
        self.equipment = dto.equipment
        self.target = dto.target
        self.secondaryMuscles = dto.secondaryMuscles
        self.instructions = dto.instructions
        
        if hasGifData, let cachedURL = ExerciseImageCache.shared.getCachedGifURL(for: dto.id) {
            // Use local cached file URL
            self.gifUrl = cachedURL
        } else {
            // Use placeholder
            self.gifUrl = URL(string: "https://media0.giphy.com/media/v1.Y2lkPTc5MGI3NjExa2t3bzl4MDU1dTZscjF1cXoweWhld2Jhcm5pdHVkajd2aWJ1N25vYyZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/zIOdLMZDcBDc2gk6vV/giphy.gif")!
        }
    }
}
```

## Step 4: TaskGroup Implementation

```swift
// Add to ExerciseService.swift
extension ExerciseService {
    func fetchAndCacheExercisesWithGifs() async throws {
        // First, fetch the exercise list
        let (data, response) = try await URLSession.shared.data(for: ExerciseV2Request.request())
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw ExerciseServiceError.invalidResponse
        }
        
        let exerciseDTOs = try JSONDecoder().decode([ExerciseV2DTO].self, from: data)
        Log.info("Fetched \(exerciseDTOs.count) exercises, now fetching GIF data...")
        
        // Fetch GIFs concurrently with limited concurrency
        let exercisesWithGifs = try await withThrowingTaskGroup(of: ExerciseV2.self, returning: [ExerciseV2].self) { group in
            
            // Limit concurrent requests (GIFs are larger, so use fewer concurrent requests)
            let semaphore = AsyncSemaphore(value: 3)
            
            for dto in exerciseDTOs {
                group.addTask { [weak self] in
                    await semaphore.wait()
                    defer { semaphore.signal() }
                    
                    return await self?.fetchExerciseWithGif(dto: dto) ?? ExerciseV2(from: dto)
                }
            }
            
            var exercises: [ExerciseV2] = []
            for try await exercise in group {
                exercises.append(exercise)
            }
            return exercises
        }
        
        networkState = .loaded(exercises: exercisesWithGifs)
        Log.info("Successfully loaded \(exercisesWithGifs.count) exercises with GIF data")
    }
    
    private func fetchExerciseWithGif(dto: ExerciseV2DTO) async -> ExerciseV2 {
        // Check if GIF is already cached
        if ExerciseImageCache.shared.isCached(exerciseId: dto.id) {
            Log.debug("Using cached GIF for exercise \(dto.id)")
            return ExerciseV2(from: dto, hasGifData: true)
        }
        
        do {
            // Fetch GIF data from API
            let imageRequest = ExerciseV2Request.imageRequest(exerciseId: dto.id)
            let (gifData, gifResponse) = try await URLSession.shared.data(for: imageRequest)
            
            if let httpResponse = gifResponse as? HTTPURLResponse, 
               httpResponse.statusCode == 200,
               httpResponse.value(forHTTPHeaderField: "Content-Type")?.contains("image/gif") == true {
                
                // Cache the GIF data
                ExerciseImageCache.shared.cacheGif(gifData, for: dto.id)
                
                Log.debug("Successfully fetched and cached GIF for exercise \(dto.id) (\(gifData.count) bytes)")
                return ExerciseV2(from: dto, hasGifData: true)
            } else {
                Log.warning("Failed to fetch GIF for exercise \(dto.id): HTTP \(httpResponse?.statusCode ?? 0)")
                return ExerciseV2(from: dto) // Use placeholder
            }
        } catch {
            Log.warning("Error fetching GIF for exercise \(dto.id): \(error)")
            return ExerciseV2(from: dto) // Use placeholder
        }
    }
}
```

## Step 5: Custom AsyncImage Component

```swift
// File: CachedGifAsyncImage.swift
import SwiftUI

struct CachedGifAsyncImage<Content: View, Placeholder: View>: View {
    let exerciseId: String
    let fallbackURL: URL
    let content: (Image) -> Content
    let placeholder: () -> Placeholder
    
    @State private var image: UIImage?
    @State private var isLoading = false
    
    var body: some View {
        Group {
            if let image = image {
                content(Image(uiImage: image))
            } else {
                if isLoading {
                    placeholder()
                } else {
                    // Fallback to regular AsyncImage for placeholder URL
                    AsyncImage(url: fallbackURL) { asyncImage in
                        content(asyncImage)
                    } placeholder: {
                        placeholder()
                    }
                }
            }
        }
        .onAppear {
            loadCachedImage()
        }
    }
    
    private func loadCachedImage() {
        // Try to load from cache first
        if let cachedData = ExerciseImageCache.shared.getCachedGif(for: exerciseId),
           let uiImage = UIImage(data: cachedData) {
            self.image = uiImage
        }
    }
}

// Usage:
/*
CachedGifAsyncImage(
    exerciseId: exercise.id,
    fallbackURL: exercise.gifUrl
) { image in
    image
        .resizable()
        .aspectRatio(contentMode: .fit)
} placeholder: {
    ProgressView()
}
.frame(width: 50, height: 50)
*/
```

## Step 6: Cache Management Extensions

```swift
// Add to ExerciseService.swift
extension ExerciseService {
    func clearGifCache() {
        ExerciseImageCache.shared.clearCache()
        Log.info("Cleared exercise GIF cache")
    }
    
    func getCacheSize() -> String {
        let cacheURL = ExerciseImageCache.shared.cacheDirectory
        let resourceKeys: [URLResourceKey] = [.fileSizeKey]
        
        guard let enumerator = FileManager.default.enumerator(
            at: cacheURL,
            includingPropertiesForKeys: resourceKeys,
            options: [.skipsHiddenFiles]
        ) else { return "0 MB" }
        
        var totalSize: Int64 = 0
        for case let fileURL as URL in enumerator {
            guard let resourceValues = try? fileURL.resourceValues(forKeys: Set(resourceKeys)),
                  let fileSize = resourceValues.fileSize else { continue }
            totalSize += Int64(fileSize)
        }
        
        let formatter = ByteCountFormatter()
        formatter.countStyle = .file
        return formatter.string(fromByteCount: totalSize)
    }
}
```

## Implementation Notes

### When to Implement:
- When you need offline GIF support
- When you want to minimize API calls
- When user experience with images is critical

### Complexity Considerations:
- Adds significant caching infrastructure
- Requires cache management (size limits, expiration)
- More complex error handling
- Storage space considerations

### Alternative Approaches:
1. **Simple approach**: Just use the API image endpoint with regular AsyncImage (no caching)
2. **URL caching**: If API provided URLs instead of direct GIF data
3. **Lazy loading**: Load GIFs only when user scrolls to them

### Performance Impact:
- Initial load: Slower (downloading all GIFs)
- Subsequent loads: Much faster (cached)
- Storage: ~1-5MB per exercise GIF
- Memory: Configurable via NSCache limits

## Usage Decision:
Consider implementing this when:
- ✅ Users frequently browse exercises
- ✅ Offline support is important
- ✅ API rate limits are restrictive
- ❌ Simple placeholder GIFs are sufficient
- ❌ Users rarely view exercise details
