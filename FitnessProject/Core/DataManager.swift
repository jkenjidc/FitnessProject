//
//  DataManager.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/25/24.
//

import Foundation
import FirebaseFirestore
import Firebase
import FirebaseStorage

extension Array {
    mutating func mutatingForEach(_ body: (inout Element) throws -> Void) rethrows {
        for index in indices {
            try body(&self[index])
        }
    }
}

@Observable
final class DataManager {
    var user = CurrentUser()
    private let userCollection = Firestore.firestore().collection("users")
    private let storageRef = Storage.storage().reference()
    private let rootStoragePath = "profile_images"
    static let shared = DataManager()
    private init() {}
    
    // MARK: DB HELPERS
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
    
    func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
    
    // MARK: Loading users
    func loadUser() async throws {
        user = try await getUser(userId: AuthManager.shared.authProfile?.uid ?? "")
    }
    
    func getUser(userId: String) async throws -> CurrentUser {
        try await userDocument(userId: userId).getDocument(as: CurrentUser.self, decoder: decoder)
        
    }
    
    // MARK: Data creation and updating
    func createNewUser(user: CurrentUser) async throws {
        try userDocument(userId: user.id).setData(from: user, merge: false, encoder: encoder)
        try await loadUser()
    }
    
    func addRoutine(routine: Routine) async throws {
        if !user.routines.contains(routine){
            user.routines.append(routine)
        } else {
            if let index = user.routines.firstIndex(where: {$0.id == routine.id}){
                user.routines[index] = routine
            }
        }
        try userDocument(userId: user.id).setData(from: user, merge: true, encoder: encoder)
        try await self.loadUser()
    }
    
    //used for anonymous account linking
    func updateUser(user: CurrentUser) async throws {
        try userCollection.document(user.id).setData(from: user, merge: false, encoder: encoder)
        try await loadUser()
    }
    
    //used for
    func updateCurrentUser() async throws {
        try userCollection.document(user.id).setData(from: user, merge: false, encoder: encoder)
        try await loadUser()
    }
    
    func uploadImage(image: UIImage) async throws {
        let profileImageRef = storageRef.child("\(rootStoragePath)/\(UUID().uuidString).jpg")
        let imageData = image.jpegData(compressionQuality: 0.8)
        if let unwrappedImageData = imageData {
            let uploadTask = profileImageRef.putData(unwrappedImageData, metadata: nil){ metadata, error in
                if error == nil && metadata != nil {
                    
                } else {
                    print(error?.localizedDescription ?? "")
                }
            }
        }
        
    }
    func switchWeightUnits() async throws {
        let switchValue = user.preferences.usingImperialWeightUnits ? 1/2.2 : 2.2
        user.routines.mutatingForEach { routine in
            routine.exercises.mutatingForEach { exercise in
                exercise.sets.mutatingForEach { exerciseSet in
                    exerciseSet.weight = exerciseSet.weight * switchValue
                }
            }
        }
        try await updateCurrentUser()
        
    }
    
    // MARK: Data deletions
    func deleteUser() async throws {
        try await userCollection.document(user.id).delete()
        self.user = CurrentUser()
    }
    
    func deleteRoutine(at index: IndexSet) async throws {
        user.routines.remove(atOffsets: index)
        let encodedRoutines = try user.routines.map { try encoder.encode($0)}
        
        try await userCollection.document(user.id).updateData(["routines": encodedRoutines])
    }
}
