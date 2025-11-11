//
//  AuthManager.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/19/24.
//

import Foundation
import FirebaseAuth
import SwiftUI

@Observable
final class AuthManager {
    static let shared = AuthManager()
    private(set) var authProfile: AuthDataResultModel? = nil
    private init() {}
    
    //initalized to false because of full screen cover bindin g, logically this should be true but the full screen cover behaves not as intended when set as true
    var isSignedOut = false
    var isAnonymous = false
    var signOutBinding: Binding<Bool> {
        Binding(
            get: { self.isSignedOut },
            set: { self.isSignedOut = $0 }
        )
    }
    
    // MARK: AUTH HELPERS
    func handleAuthError(_ error: Error) -> AuthError {
        let nsError = error as NSError
        
        // Print the error code to debug
        Log.info("Firebase Error Code: \(nsError.code)")
        
        switch nsError.code {
        case AuthErrorCode.emailAlreadyInUse.rawValue:
            return .emailInUse
        case AuthErrorCode.invalidEmail.rawValue:
            return .invalidEmail
        case AuthErrorCode.weakPassword.rawValue:
            return .weakPassword
        case AuthErrorCode.userNotFound.rawValue:
            return .userNotFound
        case AuthErrorCode.wrongPassword.rawValue:
            return .wrongPassword
        case AuthErrorCode.networkError.rawValue:
            return .networkError
        case AuthErrorCode.tooManyRequests.rawValue:
            return .tooManyRequests
        case AuthErrorCode.invalidCredential.rawValue:
            return .invalidCredentials
        case AuthErrorCode.userDisabled.rawValue:
            return .userDisabled
        default:
            print("Unhandled error code: \(nsError.code)")
            return .unknownError(error)
        }
    }
    
    func getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        
        return AuthDataResultModel(user: user)
    }
    
    func loadAuthProfile() throws {
        self.authProfile = try getAuthenticatedUser()
    }
    
    func checkAuth() throws{
        let authUser = try? getAuthenticatedUser()
        isSignedOut = authUser == nil
        isAnonymous = authUser?.isAnonymous ?? false
        try loadAuthProfile()
    }
    
    // MARK: ACCOUNT CREATIONS
    @discardableResult
    func createUser(email: String, password: String) async throws -> AuthDataResultModel{
        do {
            let authDataResult =  try await Auth.auth().createUser(withEmail: email, password: password)
            try checkAuth()
            return AuthDataResultModel(user: authDataResult.user)
        } catch {
            throw handleAuthError(error)
        }
    }
    
    @discardableResult
    func linkEmail(email: String, password: String) async throws -> AuthDataResultModel {
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        
        guard let user  = Auth.auth().currentUser else {
            throw URLError(.badURL)
        }
        
        let authDataResult = try await user.link(with: credential)
        try checkAuth()
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    // MARK: ACCOUNT SIGN IN
//    @discardableResult
    func signInUser(email: String, password: String) async throws{
        do {
            let _ =  try await Auth.auth().signIn(withEmail: email, password: password)
            try checkAuth()
        } catch {
            throw handleAuthError(error)
        }
        
    }
    
    @discardableResult
    func signInAnonymously() async throws -> AuthDataResultModel {
        
        let authDataResult =  try await Auth.auth().signInAnonymously()
        try checkAuth()
        
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    // MARK: AUTH PROFILE EDITORS
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
    
    func resetPassword(email: String)  async throws {
        guard !email.isEmpty else { return }
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
        } catch {
            print(error)
        }
    }
    
    func deleteAccount() async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badURL)
        }
        
        try await user.delete()
        isSignedOut = true
        authProfile = nil
    }
    
    //    func updateEmail(email: String) async throws {
    //        guard let user = Auth.auth().currentUser else {
    //            throw URLError(.badServerResponse)
    //        }
    //
    //        try await user.updateEmail(to: email)
    //    }
    
    // MARK: ACCOUNT SIGN OUT
    func signOut() throws {
        do {
            try Auth.auth().signOut()
            self.isSignedOut = true
            DataManager.shared.routines = [Routine]()
        }catch {
            print(error)
        }
    }
    
    
}
