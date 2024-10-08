//
//  DataManager.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/25/24.
//

import Foundation
import FirebaseFirestore
import Firebase

@MainActor
@Observable
final class DataManager {
    var user = CurrentUser()
    private let userCollection = Firestore.firestore().collection("users")
    @MainActor static let shared = DataManager()
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
        try await DataManager.shared.loadUser()
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
    
    func updateUser(user: CurrentUser) async throws {
        try userCollection.document(user.id).setData(from: user, merge: false, encoder: encoder)
        try await loadUser()
    }
    
    // MARK: Data deletions
    func deleteUser(user: CurrentUser) async throws {
        try await userCollection.document(user.id).delete()
        self.user = CurrentUser()
    }
    
    func deleteRoutine(at index: IndexSet) async throws {
        user.routines.remove(atOffsets: index)
        let encodedRoutines = try user.routines.map { try encoder.encode($0)}
        
        try await userCollection.document(user.id).updateData(["routines": encodedRoutines])
    }
}
