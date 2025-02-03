//
//  AnonymousSignInTests.swift
//  FitnessProjectTests
//
//  Created by Kenji Dela Cruz on 10/1/24.
//

import Testing
import FirebaseAuth
@testable import FitnessProject

@Suite("AuthManagerTests", .serialized)
final class AuthManagerTests {
    static let validEmail = "test@email.com"
    static let validPassword = "Test123"
    static let invalidEmail = "5555test"
    static let invalidPassword = "t"
    
    @discardableResult
    func signInAnonymously() async throws -> AuthDataResultModel {
        try await AuthManager.shared.signInAnonymously()
    }
    
    @discardableResult
    func signUpWithCredentials(email: String, password: String) async throws -> AuthDataResultModel {
        try await AuthManager.shared.createUser(email: email, password: password)
    }
    
    deinit {
        guard let user = Auth.auth().currentUser else {
            return
        }
        Task{
            try await AuthManager.shared.deleteAccount()
        }
    }
    
    @Test("Anonymous Sign In")
    func testAnonymousSignIn() async throws {
        let authResult = try await signInAnonymously()
        #expect(authResult != nil)
    }
    
    @Test("User Is Anonymous")
    func testUserIsAnonymous() async throws {
        try await signInAnonymously()
        #expect(AuthManager.shared.isAnonymous == true)
    }
    
    @Test("User Is Not Anonymous")
    func testUserIsNotAnonymous() async throws {
        try await signUpWithCredentials(email: AuthManagerTests.validEmail, password: AuthManagerTests.validPassword)
        #expect(AuthManager.shared.isAnonymous == false)
    }
    
    @Test("Invalid Sign Up")
    func testInvalidSignUp() async throws {
        await #expect(throws: AuthError.invalidEmail) {
            try await signUpWithCredentials(email: AuthManagerTests.invalidEmail, password: AuthManagerTests.invalidPassword)
        }
    }
    
    @Test("User Is Not Signed Out")
    func testUserIsSignedOut() async throws {
        try await signInAnonymously()
        #expect(AuthManager.shared.isSignedOut == false)
    }
    
    @Test("Sign Up with Valid and Invalid Credentials", arguments: [
        (email: validEmail, password: validPassword, expectedSuccess: true),
        (email: invalidEmail, password: validPassword, expectedSuccess: false),
        (email: validEmail, password: invalidPassword, expectedSuccess: false),
        (email: invalidEmail, password: invalidPassword, expectedSuccess: false)
    ])
    func testSignUpWithCredentials(email: String, password: String, expectedSuccess: Bool) async throws {
        if expectedSuccess {
            let authResult = try await signUpWithCredentials(email: email, password: password)
            #expect(authResult != nil)
        } else {
            await #expect(throws: AuthError.self) {
                try await signUpWithCredentials(email: email, password: password)
            }
        }
    }
}
