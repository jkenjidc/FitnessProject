//
//  RoutineCreationTests.swift
//  FitnessProjectTests
//
//  Created by Kenji Dela Cruz on 10/2/24.
//

import XCTest
@testable import FitnessProject

final class RoutineCreationTests: XCTestCase {
    let testEmail =  "testingEmail@test.com"
    let password =  "testPassword123"
    
    override func setUp() async throws {
        try await super.setUp()
        let user = try await AuthManager.shared.createUser(email: testEmail, password: password)
        try await DataManager.shared.createNewUser(user: CurrentUser(auth: user))
        try await DataManager.shared.loadUser()
    }
    
    
    func testRoutineCreation() async throws {
        let set = ExerciseSet(weight: 50, reps: 8)
        let exercise = Exercise(name: "Sample Exercise", sets: [set])
        let routine = Routine(name: "Test Routine", daysToDo: [], datesDone: [], exercises: [exercise])
        try await DataManager.shared.addRoutine(routine: routine)
        let user = await DataManager.shared.user
        XCTAssertFalse(user.routines.isEmpty)
    }
//    
    override func tearDown() async throws{
        if await AuthManager.shared.authProfile != nil {
            try await DataManager.shared.deleteUser(user: DataManager.shared.user)
            try await AuthManager.shared.deleteAccount()
        }
    }
    
    

}
