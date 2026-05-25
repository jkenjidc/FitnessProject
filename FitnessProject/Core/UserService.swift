//
//  UserService.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 10/21/25.
//

import Foundation
import UIKit
import SwiftUI
import PhotosUI
import FirebaseFirestore
import FirebaseStorage
import Observation

@Observable
class UserService {
    var user: CurrentUser = CurrentUser()
    var profileImage: Image?

    // MARK: - Dependencies
    private let userCollection = Firestore.firestore().collection("users")
    private let storageRef = Storage.storage().reference()
    private let rootStoragePath = "profileImages"

    // MARK: - User Data Operations

    func loadUser(userId: String) async throws {

        do {
            user = try await getUser(userId: userId)

            if let profileImageUrl = user.profileImageUrl {
                try await downloadProfileImage(path: profileImageUrl)
            }
            loadCachedProfileImage()

            Log.info("User loaded successfully: \(user.name)")
        } catch {
            Log.error("Failed to load user: \(error)")
            throw error
        }
    }

    func createUser(_ user: CurrentUser) async throws {
        do {
            try userDocument(userId: user.id).setData(from: user, merge: false)
            Log.info("User created successfully")
            try await loadUser(userId: user.id)
        } catch {
            Log.error("Failed to create user: \(error)")
            throw error
        }
    }
    // TODO: figure out linking another time
//    func linkAnonymousUser() async throws {
//        do {
//            var updatedUser = user
//            updatedUser.isAnonymous = false
//            try userCollection.document(updatedUser.id).setData(from: updatedUser, merge: false)
//            try await loadUser(userId: updatedUser.id)
//            Log.info("User updated successfully")
//        } catch {
//            Log.error("Failed to update user: \(error)")
//            throw error
//        }
//    }

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
            self.profileImage = nil

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

    func removeRoutineIds(_ routineIdsToDelete: [String]) async throws {
        guard let routines = user.routines else { return }

        // Store original state for rollback
        let originalRoutines = routineIdsToDelete

        do {
            // 1. Delete from local first
            user.routines = user.routines?.filter { !routineIdsToDelete.contains($0) }

            // 2. Update remote state
            try await updateCurrentUser()

            Log.info("Successfully deleted \(routineIdsToDelete.count) routines")

        } catch {

            Log.error("Failed to delete routines, rolled back changes: \(error)")
            throw error
        }
    }

    // MARK: - Profile Image Management

    /// Loads the cached profile image bytes into `profileImage` if a cache file exists.
    /// No-op when the cache is missing.
    func loadCachedProfileImage() {
        guard let data = try? cachedProfileImageData(),
              let uiImage = UIImage(data: data) else {
            profileImage = nil
            return
        }
        profileImage = Image(uiImage: uiImage)
    }

    /// Reads the bytes from a PhotosPicker selection, uploads them, caches locally, and
    /// updates `profileImage`.
    func uploadProfileImage(from item: PhotosPickerItem) async throws {
        guard let data = try await item.loadTransferable(type: Data.self),
              let uiImage = UIImage(data: data),
              let jpeg = uiImage.jpegData(compressionQuality: 0.8) else {
            throw NSError(
                domain: "UserService",
                code: 1,
                userInfo: [NSLocalizedDescriptionKey: "Could not decode picker selection as image"]
            )
        }
        profileImage = Image(uiImage: uiImage)
        try await uploadProfileImage(jpeg)
    }

    /// Uploads JPEG bytes to Firebase Storage, updates the user's profileImageUrl, and
    /// writes the bytes to the local cache.
    func uploadProfileImage(_ data: Data) async throws {
        let path = "\(rootStoragePath)/\(user.id)/profileImage.jpeg"
        let profileImageRef = storageRef.child(path)

        do {
            _ = try await profileImageRef.putDataAsync(data, metadata: nil)
            self.user.profileImageUrl = path
            try await updateCurrentUser()
            try cacheProfileImage(data)
            Log.info("Profile image uploaded successfully")
        } catch {
            Log.error("Failed to upload profile image: \(error)")
            throw error
        }
    }

    /// Downloads the profile image at the given Firebase Storage path into the local cache,
    /// unless a cached copy already exists.
    func downloadProfileImage(path: String) async throws {
        let filename = cachedProfileImageURL()
        guard !FileManager.default.fileExists(atPath: filename.path()) else {
            Log.info("Profile image already cached")
            return
        }

        let profileImageRef = storageRef.child(path)
        do {
            let data = try await profileImageRef.data(maxSize: 5 * 1024 * 1024)
            try data.write(to: filename)
            Log.info("Profile image downloaded and cached")
        } catch {
            Log.error("Failed to download profile image: \(error)")
            throw error
        }
    }

    func cacheProfileImage(_ data: Data) throws {
        try data.write(to: cachedProfileImageURL())
        Log.info("Profile image cached locally")
    }

    func clearCachedProfileImage() throws {
        let filename = cachedProfileImageURL()
        let fileManager = FileManager.default

        if fileManager.fileExists(atPath: filename.path()) {
            try fileManager.removeItem(at: filename)
            Log.info("Cached profile image cleared")
        }
        profileImage = nil
    }

    private func cachedProfileImageData() throws -> Data? {
        let url = cachedProfileImageURL()
        guard FileManager.default.fileExists(atPath: url.path()) else { return nil }
        return try Data(contentsOf: url)
    }

    private func cachedProfileImageURL() -> URL {
        getDocumentsDirectory().appendingPathComponent(FileNames.profileImage.rawValue)
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
}

// MARK: - File Names
public enum FileNames: String {
    case profileImage = "profileImage.jpeg"
}
