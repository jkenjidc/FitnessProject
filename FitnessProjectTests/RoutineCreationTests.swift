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
    let testExerciseName = "Test Exercise Name"
    let sampleRoutine = Routine.example[0]
    let coordinator = AppCoordinator()

    override func setUp() async throws {
        try await super.setUp()
        try await coordinator.signUp(testEmail, password, testName)
        try await DataManager.shared.loadUser()
    }
    
    func testRoutineCreation() async throws {
        try await DataManager.shared.createRoutine(routine: sampleRoutine)
        let routines =  DataManager.shared.routines
        XCTAssertFalse(routines.isEmpty)
    }
    
    func testStartTimer() {
        let createRoutineViewModelInTimerMode = CreateRoutineScreen.ViewModel(routine: sampleRoutine, screenMode: .timer)
        XCTAssertTrue(createRoutineViewModelInTimerMode.isTimerActive)
    }
    
    func testPauseTimer(){
        let createRoutineViewModelInTimerMode = CreateRoutineScreen.ViewModel(routine: sampleRoutine, screenMode: .timer)
        createRoutineViewModelInTimerMode.isTimerActive.toggle()
        XCTAssertFalse(createRoutineViewModelInTimerMode.isTimerActive)
    }
    
    func testEndTimer(){
        let createRoutineViewModelInTimerMode = CreateRoutineScreen.ViewModel(routine: sampleRoutine, screenMode: .timer)
        createRoutineViewModelInTimerMode.isTimerActive = false
        XCTAssertFalse(createRoutineViewModelInTimerMode.isTimerActive)
    }
    
    func testSavingExercisesToCurrentRoutine(){
        let createRoutineViewModelInCreationMode = CreateRoutineScreen.ViewModel()
        createRoutineViewModelInCreationMode.newExerciseName = testExerciseName
        createRoutineViewModelInCreationMode.saveExercise()
        XCTAssertTrue(createRoutineViewModelInCreationMode.routine.exercises.contains(where: { $0.name == testExerciseName}))
    }
    
    func testRoutineHistorySaving(){
        let createRoutineViewModelInTimerMode = CreateRoutineScreen.ViewModel(routine: sampleRoutine, screenMode: .timer)
        createRoutineViewModelInTimerMode.finishRoutine()
        XCTAssertTrue(((DataManager.shared.user.routineHistory?.isEmpty) != nil))
    }
    
    func testDeletingExerciseGivenAnExercise(){
        let createRoutineViewModelInCreationMode = CreateRoutineScreen.ViewModel(routine: sampleRoutine, screenMode: .editing)
        let countBeforeDeletion = createRoutineViewModelInCreationMode.routine.exercises.count
        createRoutineViewModelInCreationMode.deleteExercise(exercise: sampleRoutine.exercises[0])
        let countAfterDeletion = createRoutineViewModelInCreationMode.routine.exercises.count
        XCTAssertTrue(countBeforeDeletion == countAfterDeletion + 1)
        

    }

    override func tearDown() async throws {
        if Auth.auth().currentUser != nil {
            try await coordinator.deleteAccount()
        }
        try await super.tearDown()
    }
    
    

}
