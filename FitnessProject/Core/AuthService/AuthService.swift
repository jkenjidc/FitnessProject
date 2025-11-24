//
//  AuthService.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 10/21/25.
//

import Foundation
import FirebaseAuth
import SwiftUI

@Observable
class AuthService {
    var authState: AuthState = .authenticating

    // MARK: - Authentication Operations
    func signUp(email: String, password: String) async throws -> AuthData {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        Log.info("Sign up successful")
        return AuthData(user: authDataResult.user)
    }

    func signInAnonymously() async throws -> AuthData {
        let authDataResult = try await Auth.auth().signInAnonymously()
        Log.info("Anonymous sign in successful")
        return AuthData(user: authDataResult.user)
    }


    func signIn(email: String, password: String) async {
        authState = .authenticating

        do {
            let authData = try await Auth.auth().signIn(withEmail: email, password: password)
            authState = .authenticated(AuthData(user: authData.user))
            Log.info("Sign in successful")
        } catch {
            handleAuthError(error)
        }
    }


    func signOut() {
        do {
            try Auth.auth().signOut()
            self.authState = .unauthenticated
            Log.info("Sign out successful")
        } catch {
            handleAuthError(error)
        }
    }

    func linkAnonymousAccount(email: String, password: String) async throws {
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)

        guard let user = Auth.auth().currentUser else {
            throw AuthError.userNotFound
        }

        try await user.link(with: credential)
        Log.info("Account linking successful")
    }

    // MARK: - Password Management

    func updatePassword(_ newPassword: String) async throws {
        guard let user = Auth.auth().currentUser else {
            throw AuthError.userNotFound
        }

        do {
            try await user.updatePassword(to: newPassword)
            Log.info("Password updated successfully")
        } catch {
            throw AuthError(error)
        }
    }

    func resetPassword(email: String) async throws {
        guard !email.isEmpty else {
            throw AuthError.invalidEmail
        }

        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
            Log.info("Password reset email sent")
        } catch {
            throw AuthError(error)
        }
    }

    // MARK: - Account Management
    func deleteAccount() async throws {
        guard let user = Auth.auth().currentUser else {
            throw AuthError.userNotFound
        }

        do {
            try await user.delete()
            self.authState = .unauthenticated
            Log.info("Account deleted successfully")
        } catch {
            throw AuthError(error)
        }
    }

    // MARK: - Private Helpers
    func checkAuth() {
        if let firebaseUser = Auth.auth().currentUser {
            authState = .authenticated(AuthData(user: firebaseUser))
            Log.info("User authenticated")
        } else {
            authState = .unauthenticated
            Log.info("User not authenticated")
        }
    }
}
