//
//  UserService.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 10/21/25.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import Observation

@Observable
class UserService {
    // MARK: - State Management
    enum LoadingState {
        case idle
        case loading
        case loaded
        case error(Error)
    }
    
    var loadingState: LoadingState = .idle
    var user: CurrentUser = CurrentUser()
    
    // MARK: - Dependencies
    private let userCollection = Firestore.firestore().collection("users")
    private let storageRef = Storage.storage().reference()
    private let rootStoragePath = "profileImages"
    
    private let encoder: Firestore.Encoder = {
        let encoder = Firestore.Encoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()
    
    private let decoder: Firestore.Decoder = {
        let decoder = Firestore.Decoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    // MARK: - User Data Operations
    
    func loadUser(userId: String) async throws {
        loadingState = .loading
        
        do {
            user = try await getUser(userId: userId)
            
            // Load profile image if available
            if let profileImageUrl = user.profileImageUrl {
                try await getProfileImage(path: profileImageUrl)
            }
            
            loadingState = .loaded
            Log.info("User loaded successfully: \(user.name)")
        } catch {
            loadingState = .error(error)
            Log.error("Failed to load user: \(error)")
            throw error
        }
    }
    
    func createUser(_ user: CurrentUser) async throws {
        do {
            try userDocument(userId: user.id).setData(from: user, merge: false)
            try await loadUser(userId: user.id)
            Log.info("User created successfully: \(user.id)")
        } catch {
            Log.error("Failed to create user: \(error)")
            throw error
        }
    }
    
    func updateUser(_ user: CurrentUser) async throws {
        do {
            var updatedUser = user
            updatedUser.isAnonymous = false
            try userCollection.document(updatedUser.id).setData(from: updatedUser, merge: false)
            try await loadUser(userId: updatedUser.id)
            Log.info("User updated successfully")
        } catch {
            Log.error("Failed to update user: \(error)")
            throw error
        }
    }
    
    func updateCurrentUser(isLinking: Bool = false, newName: String? = nil) async throws {
        do {
            if isLinking {
                self.user.isAnonymous = false
                if let name = newName {
                    self.user.name = name
                }
            }
            
            try userCollection.document(user.id).setData(from: self.user, merge: false)
            try await loadUser(userId: user.id)
            Log.info("Current user updated successfully")
        } catch {
            Log.error("Failed to update current user: \(error)")
            throw error
        }
    }
    
    func deleteUser() async throws {
        do {
            try await userCollection.document(user.id).delete()
            
            // Clear local state
            self.user = CurrentUser()
            loadingState = .idle
            
            Log.info("User deleted successfully")
        } catch {
            Log.error("Failed to delete user: \(error)")
            throw error
        }
    }
    
    // MARK: - Routine ID Management
    
    func addRoutineId(_ routineId: String) async throws {
        if user.routines != nil {
            user.routines?.append(routineId)
        } else {
            user.routines = [routineId]
        }
        
        try await updateCurrentUser()
        Log.info("Added routine ID to user: \(routineId)")
    }
    
    func removeRoutineId(_ routineId: String) async throws {
        user.routines?.removeAll { $0 == routineId }
        try await updateCurrentUser()
        Log.info("Removed routine ID from user: \(routineId)")
    }
    
    // MARK: - Profile Image Management
    
    func uploadProfileImage(_ image: UIImage) async throws {
        let path = "\(rootStoragePath)/\(user.id)/profileImage.jpeg"
        let profileImageRef = storageRef.child(path)
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw NSError(domain: "UserService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to data"])
        }
        
        do {
            let _ = try await profileImageRef.putDataAsync(imageData, metadata: nil)
            
            // Update user with image path
            self.user.profileImageUrl = path
            try await updateCurrentUser()
            
            // Cache image locally
            try cacheImage(from: image)
            
            Log.info("Profile image uploaded successfully")
        } catch {
            Log.error("Failed to upload profile image: \(error)")
            throw error
        }
    }
    
    func getProfileImage(path: String) async throws {
        let filename = getDocumentsDirectory().appendingPathComponent(FileNames.profileImage.rawValue)
        
        // Check if already cached locally
        guard !FileManager.default.fileExists(atPath: filename.path()) else {
            Log.info("Profile image loaded from cache")
            return
        }
        
        let profileImageRef = storageRef.child(path)
        
        do {
            let data = try await profileImageRef.data(maxSize: 5 * 1024 * 1024)
            try data.write(to: filename)
            Log.info("Profile image downloaded and cached")
        } catch {
            Log.error("Failed to get profile image: \(error)")
            throw error
        }
    }
    
    func clearCachedProfileImage() throws {
        let filename = getDocumentsDirectory().appendingPathComponent(FileNames.profileImage.rawValue)
        let fileManager = FileManager.default
        
        if fileManager.fileExists(atPath: filename.path()) {
            try fileManager.removeItem(at: filename)
            Log.info("Cached profile image cleared")
        }
    }
    
    // MARK: - User Preferences
    
//    func updatePreferences(_ preferences: CurrentUser.Preferences) async throws {
//        user.preferences = preferences
//        try await updateCurrentUser()
//        Log.info("User preferences updated")
//    }
    
    func toggleWeightUnits() async throws {
        user.preferences.usingImperialWeightUnits.toggle()
        try await updateCurrentUser()
        Log.info("Weight units toggled to: \(user.preferences.usingImperialWeightUnits ? "Imperial" : "Metric")")
    }
    
    func getWeightMultiplier() -> Double {
        return user.preferences.usingImperialWeightUnits ? 1/2.2 : 2.2
    }
    
    // MARK: - Private Helpers
    
    private func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
    
    private func getUser(userId: String) async throws -> CurrentUser {
        try await userDocument(userId: userId).getDocument(as: CurrentUser.self)
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    private func cacheImage(from inputImage: UIImage) throws {
        guard let data = inputImage.jpegData(compressionQuality: 0.8) else {
            throw NSError(domain: "UserService", code: 2, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to JPEG"])
        }
        
        let filename = getDocumentsDirectory().appendingPathComponent(FileNames.profileImage.rawValue)
        try data.write(to: filename)
        Log.info("Profile image cached locally")
    }
}

// MARK: - File Names
public enum FileNames: String {
    case profileImage = "profileImage.jpeg"
}


