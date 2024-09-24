//
//  AuthManager.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/19/24.
//

import Foundation
import FirebaseAuth
import SwiftUI

@MainActor
@Observable
final class AuthManager {
    static let shared = AuthManager()
    private(set) var authProfile: AuthDataResultModel? = nil
    private init() {}
    var isSignedOut = false
    var isAnonymous = false
    var signOutBinding: Binding<Bool> {
        Binding(
                    get: { self.isSignedOut },
                    set: { self.isSignedOut = $0 }
                )
    }
    
    func loadAuthProfile() throws {
        self.authProfile = try getAuthenticatedUser()
        checkAuth()
    }
    
    func checkAuth() {
        let authUser = try? getAuthenticatedUser()
        isSignedOut = authUser == nil
        isAnonymous = authUser?.isAnonymous ?? false
        
    }
    
    @discardableResult
    func createUser(email: String, password: String) async throws -> AuthDataResultModel{
        let authDataResult =  try await Auth.auth().createUser(withEmail: email, password: password)
        checkAuth()
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    @discardableResult
    func signInUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult =  try await Auth.auth().signIn(withEmail: email, password: password)
        checkAuth()
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    func resetPassword(email: String)  async throws {
        guard !email.isEmpty else { return }
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
        } catch {
            print(error)
        }
    }
    
    func updatePassword(password: String) async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        guard !password.isEmpty else { return }
        do {
            try await user.updatePassword(to: password)
        }catch {
            print(error)
        }
    }
    
//    func updateEmail(email: String) async throws {
//        guard let user = Auth.auth().currentUser else {
//            throw URLError(.badServerResponse)
//        }
//        
//        try await user.updateEmail(to: email)
//    }
    @discardableResult
    func signInAnonymously() async throws -> AuthDataResultModel {
       let authDataResult =  try await Auth.auth().signInAnonymously()
        checkAuth()
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    func isUserAnonymous() -> Bool {
        let authUser = try? getAuthenticatedUser()
        return authUser?.isAnonymous ?? false
    }
    
    @discardableResult
    func linkEmail(email: String, password: String) async throws -> AuthDataResultModel {
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        
        guard let user  = Auth.auth().currentUser else {
            throw URLError(.badURL)
        }
        
        let authDataResult = try await user.link(with: credential)
        checkAuth()
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    func getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        
        return AuthDataResultModel(user: user)
    }
    
    func signOut() throws {
        do {
            try Auth.auth().signOut()
            self.isSignedOut = true
        }catch {
            print(error)
        }
    }
    
    
}
