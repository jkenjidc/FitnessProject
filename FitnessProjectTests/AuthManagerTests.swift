//
//  AnonymousSignInTests.swift
//  FitnessProjectTests
//
//  Created by Kenji Dela Cruz on 10/1/24.
//

import XCTest
import FirebaseAuth
@testable import FitnessProject

final class AuthManagerTests: XCTestCase {
    let validEmail = "test@email.com"
    let validPassword = "Test123"
    let invalidEmail = "5555test"
    let invalidPassword = "t"
    
    @discardableResult
    func signInAnonmously() async throws -> AuthDataResultModel {
        return try await AuthManager.shared.signInAnonymously()
    }
    
    @discardableResult
    func signUpWithValidCredentials() async throws -> AuthDataResultModel {
        
        return try await AuthManager.shared.createUser(email: validEmail, password: validPassword)
    }
    
    @discardableResult
    func signUpWithInvalidCredentials() async throws -> AuthDataResultModel {
        return try await AuthManager.shared.createUser(email: invalidEmail, password: invalidPassword)
    }
    
    func testAnonymousSignIn() async throws {
        let authResult = try await self.signInAnonmously()
        XCTAssertNotEqual(authResult, nil)
    }
    
    func testUserIsAnonymous() async throws  {
        try await signInAnonmously()
        let currentAnonymousStatus = await AuthManager.shared.isAnonymous
        XCTAssertEqual(currentAnonymousStatus, true)
    }
    
    func testUserIsNotAnonymous() async throws  {
        try await signUpWithValidCredentials()
        let currentAnonymousStatus = await AuthManager.shared.isAnonymous
        XCTAssertEqual(currentAnonymousStatus, false)
    }
    
    func testInvalidSignUp() async throws {
        do {
            try await signUpWithInvalidCredentials()
        } catch {
            XCTAssertEqual(error.localizedDescription, "The email address is badly formatted.")
        }
    }
    
    func testUserIsSignedOut() async throws{
        try await signInAnonmously()
        let currentSignedOutState = await AuthManager.shared.isSignedOut
        XCTAssertEqual(currentSignedOutState, false)
    }
    
    //reformat make tests independent
    override func tearDown() async throws{
        if await AuthManager.shared.authProfile != nil {
            try await AuthManager.shared.deleteAccount()
        }
    }
    

}
