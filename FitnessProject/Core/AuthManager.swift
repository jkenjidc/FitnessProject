//
//  AuthManager.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/19/24.
//

import Foundation
import FirebaseAuth

final class AuthManager {
    static let shared = AuthManager()
    init() {}
    
    func createUser(email: String, password: String) async throws -> AuthDataResultModel{
        let authDataResult =  try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    func getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        
        return AuthDataResultModel(user: user)
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    func signIn(email: String, password: String) {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found.")
            return
        }
        Task {
            do {
                let returnedUserData = try await AuthManager.shared.createUser(email: email, password: password)
                print("Sucess")
                print(returnedUserData)
            } catch {
                print("Error: \(error)")
            }
        }
    }
}
