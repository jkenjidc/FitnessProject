//
//  RoutineCreationTests.swift
//  FitnessProjectTests
//
//  Created by Kenji Dela Cruz on 10/2/24.
//

import XCTest
import FirebaseAuth
@testable import FitnessProject

final class RoutineCreationTests: XCTestCase {
    let testEmail =  "testingEmail@test.com"
    let password =  "testPassword123"
    let testName = "Test User"
    let sampleRoutine = Routine.example[0]
    let coordinator = AppCoordinator()

    override func setUp() async throws {
        try await super.setUp()
        try await coordinator.signUp(testEmail, password, testName)
    }

    func testRoutineCreation() async throws {
        try await coordinator.createRoutine(sampleRoutine)
        XCTAssertTrue(coordinator.routineService.routines.contains(where: { $0.id == sampleRoutine.id }))
        XCTAssertTrue(coordinator.userService.user.routines?.contains(sampleRoutine.id) == true)
    }

    func testRoutineHistorySaving() async throws {
        try await coordinator.finishRoutine(sampleRoutine, durationSeconds: 0)
        XCTAssertTrue(coordinator.userService.user.routineHistory?.contains(where: { $0.nameOfRoutine == sampleRoutine.name }) == true)
    }

    override func tearDown() async throws {
        if Auth.auth().currentUser != nil {
            try await coordinator.deleteAccount()
        }
        try await super.tearDown()
    }
}
