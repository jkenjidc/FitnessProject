//
//  AuthServiceTests.swift
//  FitnessProjectTests
//
//  Created by Kenji Dela Cruz on 10/1/24.
//

import Testing
import FirebaseAuth
@testable import FitnessProject

@Suite("AuthServiceTests", .serialized)
final class AuthServiceTests {
    static let validEmail = "test@email.com"
    static let validPassword = "Test123"
    static let invalidEmail = "5555test"
    static let invalidPassword = "t"

    let coordinator = AppCoordinator()

    // MARK: - Helpers

    @discardableResult
    func signInAnonymously() async throws -> AuthData {
        try await coordinator.authService.signInAnonymously()
    }

    @discardableResult
    func signUpWithCredentials(email: String, password: String) async throws -> AuthData {
        do {
            return try await coordinator.authService.signUp(email: email, password: password)
        } catch {
            throw AuthError(error)
        }
    }

    private func deleteCurrentUserIfNeeded() async {
        guard let user = Auth.auth().currentUser else { return }
        try? await user.delete()
    }

    /// Runs `body` and guarantees the Firebase auth account is deleted afterward,
    /// even if the body throws. Cleanup is awaited, so the next test starts from a
    /// clean state.
    private func withAuthCleanup(_ body: () async throws -> Void) async throws {
        do {
            try await body()
        } catch {
            await deleteCurrentUserIfNeeded()
            throw error
        }
        await deleteCurrentUserIfNeeded()
    }

    // MARK: - Tests

    @Test("Anonymous Sign In")
    func testAnonymousSignIn() async throws {
        try await withAuthCleanup {
            let authResult = try await signInAnonymously()
            #expect(authResult.isAnonymous == true)
        }
    }

    @Test("User Is Anonymous")
    func testUserIsAnonymous() async throws {
        try await withAuthCleanup {
            try await signInAnonymously()
            coordinator.authService.checkAuth()
            guard case .authenticated(let data) = coordinator.authService.authState else {
                Issue.record("Expected authenticated state")
                return
            }
            #expect(data.isAnonymous == true)
        }
    }

    @Test("User Is Not Anonymous")
    func testUserIsNotAnonymous() async throws {
        try await withAuthCleanup {
            try await signUpWithCredentials(email: Self.validEmail, password: Self.validPassword)
            coordinator.authService.checkAuth()
            guard case .authenticated(let data) = coordinator.authService.authState else {
                Issue.record("Expected authenticated state")
                return
            }
            #expect(data.isAnonymous == false)
        }
    }

    @Test("Invalid Sign Up")
    func testInvalidSignUp() async throws {
        await #expect(throws: AuthError.invalidEmail) {
            try await signUpWithCredentials(email: Self.invalidEmail, password: Self.invalidPassword)
        }
        await deleteCurrentUserIfNeeded()
    }

    @Test("Authenticated After Sign In")
    func testAuthenticatedAfterSignIn() async throws {
        try await withAuthCleanup {
            try await signInAnonymously()
            coordinator.authService.checkAuth()
            if case .unauthenticated = coordinator.authService.authState {
                Issue.record("Expected authenticated state, got unauthenticated")
            }
        }
    }

    @Test("Sign Up with Valid and Invalid Credentials", arguments: [
        (email: validEmail, password: validPassword, expectedSuccess: true),
        (email: invalidEmail, password: validPassword, expectedSuccess: false),
        (email: validEmail, password: invalidPassword, expectedSuccess: false),
        (email: invalidEmail, password: invalidPassword, expectedSuccess: false)
    ])
    func testSignUpWithCredentials(email: String, password: String, expectedSuccess: Bool) async throws {
        if expectedSuccess {
            try await withAuthCleanup {
                let authResult = try await signUpWithCredentials(email: email, password: password)
                #expect(authResult.uid.isEmpty == false)
            }
        } else {
            await #expect(throws: AuthError.self) {
                try await signUpWithCredentials(email: email, password: password)
            }
            await deleteCurrentUserIfNeeded()
        }
    }
}
