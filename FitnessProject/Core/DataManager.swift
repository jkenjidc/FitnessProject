//
//  DataManager.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/25/24.
//

import Foundation
import FirebaseFirestore

@MainActor
@Observable
final class DataManager {
    private let userCollection = Firestore.firestore()
        .collection("users")
    @MainActor static let shared = DataManager()
    private init() {}
    
    var user = CurrentUser()
    
    func loadUser() async throws {
        user = try await getUser(userId: AuthManager.shared.authProfile?.uid ?? "")
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
    func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
    
    func createNewUser(user: CurrentUser) async throws {
        try userDocument(userId: user.id).setData(from: user, merge: false, encoder: encoder)
        try await DataManager.shared.loadUser()
    }
      
    func getUser(userId: String) async throws -> CurrentUser {
        try await userDocument(userId: userId).getDocument(as: CurrentUser.self, decoder: decoder)
        
    }
    
    func addRoutine(routine: Routine) async throws {
        user.routines.append(routine)
        try userDocument(userId: user.id).setData(from: user, merge: true)
    }
    
    func updateUser(user: CurrentUser) async throws {
        try userCollection.document(user.id).setData(from: user, merge: false)
        try await loadUser()
    }
}
