//
//  ExercisesServices.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 8/8/25.
//

import SwiftUI
import Observation

@Observable
class ExerciseService {
    var networkState: NetworkCallState<[ExerciseV2]> = .loading
    var searchQuery: String = ""
    var selectedBodyPart: String?
    var selectedEquipment: String?

    var exercises: [ExerciseV2] {
        switch networkState {
        case .loaded(let exercises):
            return exercises
        default:
            return []
        }
    }

    var filteredExercises: [ExerciseV2] {
        exercises.filter { exercise in
            let bodyPartMatches = selectedBodyPart == nil || exercise.bodyPart == selectedBodyPart

            let selectedEquipment = selectedEquipment == nil || exercise.equipment == selectedEquipment

            let searchMatches = searchQuery.isEmpty || exercise.name.lowercased().contains(searchQuery.lowercased())

            return bodyPartMatches && selectedEquipment && searchMatches
        }
    }

    var bodyPartOptions: [String] {
        exercises.uniqueValues(for: .bodyPart)
    }

    var equipmentOptions: [String] {
        exercises.uniqueValues(for: .equipment)
    }

    func fetchExercises() async {
        Log.info("Fetching exercises data....")
        do {
            // First, try to use cache if it exists and is valid
            if let cachedExercises = try? loadCache() {
                networkState = .loaded(cachedExercises)
                Log.info("Successfully loaded \(exercises.count) exercises from cache")
                return
            }

            // If no valid cache or cache load failed, fetch from network
            try await fetchAndCacheExercises()

        } catch let exerciseError as ExerciseServiceError {
            Log.error("Exercise service error: \(exerciseError.errorDescription)")
            networkState = .error(exerciseError)
        } catch {
            Log.error("Unexpected error fetching exercises: \(error.localizedDescription)")
            networkState = .error(error)
        }
    }

    /// Fetches every page of wger exercises, then caches the mapped list to disk.
    func fetchAndCacheExercises() async throws {
        var allExercises: [ExerciseV2] = []
        var nextRequest: URLRequest? = WgerRequest.exerciseInfo()

        while let request = nextRequest {
            let (data, response) = try await URLSession.shared.data(for: request)

            // Validate the response
            guard let httpResponse = response as? HTTPURLResponse else {
                throw ExerciseServiceError.invalidResponse
            }

            guard httpResponse.statusCode == 200 else {
                throw ExerciseServiceError.httpError(statusCode: httpResponse.statusCode)
            }

            let page: WgerExercisePage
            do {
                page = try JSONDecoder().decode(WgerExercisePage.self, from: data)
            } catch {
                throw ExerciseServiceError.networkDecodingFailed(underlyingError: error)
            }

            allExercises += page.results.compactMap(ExerciseV2.init)
            nextRequest = page.next.map(WgerRequest.request)
        }

        allExercises.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        networkState = .loaded(allExercises)
        Log.info("Successfully fetched \(allExercises.count) exercises")

        do {
            try saveCache(allExercises)
        } catch {
            Log.error("Failed to cache exercises: \(error.localizedDescription)")
        }
    }

    // MARK: Disk cache

    private struct ExerciseCache: Codable {
        let expirationDate: Date
        let exercises: [ExerciseV2]
    }

    private var cacheFileURL: URL {
        URL.cachesDirectory.appendingPathComponent("wgerExercises.json")
    }

    /// Returns cached exercises, or `nil` if there is no cache or it has expired.
    private func loadCache() throws -> [ExerciseV2]? {
        guard FileManager.default.fileExists(atPath: cacheFileURL.path) else { return nil }

        let cache: ExerciseCache
        do {
            cache = try JSONDecoder().decode(ExerciseCache.self, from: Data(contentsOf: cacheFileURL))
        } catch {
            Log.error("Cache load failed, falling back to network: \(error.localizedDescription)")
            throw ExerciseServiceError.cacheCorrupted
        }

        return Date() < cache.expirationDate ? cache.exercises : nil
    }

    private func saveCache(_ exercises: [ExerciseV2]) throws {
        let cache = ExerciseCache(expirationDate: Date.threeMonthsFromToday(), exercises: exercises)
        try JSONEncoder().encode(cache).write(to: cacheFileURL, options: .atomic)
    }
}
