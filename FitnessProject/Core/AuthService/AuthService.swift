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
    var authState: AuthState = .unauthenticated

    // Deliberately no auth check here. Firebase restores the persisted session from
    // the Keychain asynchronously after `FirebaseApp.configure()` returns, so reading
    // `currentUser` this early is a race. Call `checkAuth()` from app startup instead.

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


    func signIn(email: String, password: String) async throws -> AuthData {
        do {
            let authData = try await Auth.auth().signIn(withEmail: email, password: password)
            Log.info("Sign in successful")
            return AuthData(user: authData.user)
        } catch {
            throw AuthError(error)
        }
    }


    func signOut() throws {
        do {
            try Auth.auth().signOut()
            self.authState = .unauthenticated
            Log.info("Sign out successful")
        } catch {
            throw AuthError(error)
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

    /// Resolves the persisted session into `authState`. Must be awaited before any
    /// Firestore read, since a restored `currentUser` can exist before Firebase can
    /// mint a usable token for it.
    ///
    /// Forces a token refresh so a session that is no longer valid server-side — a
    /// deleted or disabled account — is signed out rather than left to fail the next
    /// Firestore call with a permissions error.
    @MainActor
    func checkAuth() async {
        guard let firebaseUser = Auth.auth().currentUser else {
            authState = .unauthenticated
            Log.info("User not authenticated")
            return
        }

        do {
            _ = try await firebaseUser.getIDTokenResult(forcingRefresh: true)
            authState = .authenticated(AuthData(user: firebaseUser))
            Log.info("User authenticated")
        } catch {
            let nsError = error as NSError
            if nsError.code == AuthErrorCode.networkError.rawValue {
                // Offline at launch. The session is probably fine, it just can't be
                // confirmed right now, so trust it rather than signing the user out.
                authState = .authenticated(AuthData(user: firebaseUser))
                Log.info("Offline at launch, keeping restored session unverified")
            } else {
                authState = .unauthenticated
                Log.error("Stored session is no longer valid, signing out: \(error)")
                try? Auth.auth().signOut()
            }
        }
    }
}
