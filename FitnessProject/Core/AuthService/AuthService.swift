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
    private(set) var authProfile: AuthDataResultModel? = nil

    var isAuthenticated: Bool {
        authProfile != nil
    }

    var isAnonymous: Bool {
        authProfile?.isAnonymous ?? false
    }

    // MARK: - Authentication Operations
    func signUp(email: String, password: String) async throws -> AuthDataResultModel {
        guard !email.isEmpty, !password.isEmpty else {
            throw AuthError.invalidEmail
        }

        authState = .authenticating

        do {
            let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
            checkAuth()
            Log.info("Sign up successful")
            return AuthDataResultModel(user: authDataResult.user)
        } catch {
            let authError = handleAuthError(error)
            authState = .error(authError)
            Log.error("Sign up failed: \(authError)")
            throw authError
        }
    }

    func signIn(email: String, password: String) async throws {
        guard !email.isEmpty, !password.isEmpty else {
            throw AuthError.invalidEmail
        }

        authState = .authenticating

        do {
            let _ = try await Auth.auth().signIn(withEmail: email, password: password)
            checkAuth()
            Log.info("Sign in successful")
        } catch {
            let authError = handleAuthError(error)
            authState = .error(authError)
            Log.error("Sign in failed: \(authError)")
            throw authError
        }
    }

    func signInAnonymously() async throws -> AuthDataResultModel {
        authState = .authenticating

        do {
            let authDataResult = try await Auth.auth().signInAnonymously()
            checkAuth()
            Log.info("Anonymous sign in successful")
            return AuthDataResultModel(user: authDataResult.user)
        } catch {
            let authError = handleAuthError(error)
            authState = .error(authError)
            throw authError
        }
    }

    func signOut() throws {
        do {
            try Auth.auth().signOut()
            self.authProfile = nil
            self.authState = .unauthenticated
            Log.info("Sign out successful")
        } catch {
            Log.error("Sign out failed: \(error)")
            throw error
        }
    }

    func linkAnonymousAccount(email: String, password: String) async throws -> AuthDataResultModel {
        guard !email.isEmpty, !password.isEmpty else {
            throw AuthError.invalidEmail
        }

        let credential = EmailAuthProvider.credential(withEmail: email, password: password)

        guard let user = Auth.auth().currentUser else {
            throw AuthError.userNotFound
        }

        authState = .authenticating

        do {
            let authDataResult = try await user.link(with: credential)
            checkAuth()
            Log.info("Account linking successful")
            return AuthDataResultModel(user: authDataResult.user)
        } catch {
            let authError = handleAuthError(error)
            authState = .error(authError)
            throw authError
        }
    }

    // MARK: - Password Management

    func updatePassword(_ newPassword: String) async throws {
        guard !newPassword.isEmpty else {
            throw AuthError.weakPassword
        }

        guard let user = Auth.auth().currentUser else {
            throw AuthError.userNotFound
        }

        do {
            try await user.updatePassword(to: newPassword)
            Log.info("Password updated successfully")
        } catch {
            let authError = handleAuthError(error)
            Log.error("Password update failed: \(authError)")
            throw authError
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
            let authError = handleAuthError(error)
            Log.error("Password reset failed: \(authError)")
            throw authError
        }
    }

    // MARK: - Account Management
    func deleteAccount() async throws {
        guard let user = Auth.auth().currentUser else {
            throw AuthError.userNotFound
        }

        do {
            try await user.delete()
            self.authProfile = nil
            self.authState = .unauthenticated
            Log.info("Account deleted successfully")
        } catch {
            let authError = handleAuthError(error)
            Log.error("Account deletion failed: \(authError)")
            throw authError
        }
    }

    // MARK: - Private Helpers

    private func getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        return AuthDataResultModel(user: user)
    }

    func checkAuth() {
        do {
            let authUser = try getAuthenticatedUser()
            self.authProfile = authUser
            self.authState = .authenticated(authUser)
            Log.info("User authenticated: \(authUser.uid)")
        } catch {
            self.authProfile = nil

            // Distinguish between "no user" and "check failed"
            if let authError = error as? AuthErrorCode {
                self.authState = .error(AuthError.unknownError(authError))
                Log.error("Auth check failed: \(error)")
            } else {
                // Normal case - just no user logged in
                self.authState = .unauthenticated
                Log.info("No user logged in")
            }
        }
    }

}
