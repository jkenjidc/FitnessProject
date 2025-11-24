//
//  AppCoordinator.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 10/21/25.
//

import Foundation
import Observation

@Observable
class AppCoordinator {
    // MARK: - Services
    let authService: AuthService
    let userService: UserService
    let routineService: RoutineService

    // MARK: - Initialization
    init(
        authService: AuthService = AuthService(),
        userService: UserService = UserService(),
        routineService: RoutineService = RoutineService()
    ) {
        self.authService = authService
        self.userService = userService
        self.routineService = routineService
    }

    // MARK: - App Lifecycle

    func initializeApp() async {
        // Just check auth - data loads lazily when views need it
        authService.checkAuth()

        // Only load user profile if authenticated
        if case .authenticated(let authProfile) = authService.authState {
            do {
                try await userService.loadUser(userId: authProfile.uid)
            } catch {
                Log.error("Failed to load user on init: \(error)")
                // Don't fail app launch - user can retry later
            }
        }
    }

    // MARK: - Authentication Workflows

    func signUp(email: String, password: String, name: String) async {
        authService.authState = .authenticating
        do {
            // Step 1: Create Firebase Auth account
            let authData = try await authService.signUp(email: email, password: password)

            // Step 2: Create Firestore user profile
            try await userService.createUser(CurrentUser(auth: authData))

            // Step 3: Update auth state for UI
            authService.authState = .authenticated(authData)

            // That's it - routines load when RoutineListView appears
            Log.info("User account created")
        } catch {
            // TODO: Handle creation error separately from auth errors
            // Delete auth account in case of failures
            try? await authService.deleteAccount()
            authService.handleAuthError(error)
            Log.error("Sign up failed")
        }
    }

    func signInAnonymously() async throws {
        authService.authState = .authenticating
        do {
            // Step 1: Sign in anonymously
            let authData = try await authService.signInAnonymously()

            // Step 2: Create user profile in Firestore
            try await userService.createUser(CurrentUser(auth: authData))

            // Step 3: Update auth state for UI
            authService.authState = .authenticated(authData)

            Log.info("Anonymous sign in completed")
        } catch {
            // TODO: Handle creation error separately from auth errors
            // Delete auth account in case of failures
            try? await authService.deleteAccount()
            authService.handleAuthError(error)
            Log.error("Sign in anonymously failed")
        }
    }

    func linkAnonymousAccount(email: String, password: String, name: String) async throws {
        // Step 1: Link Firebase Auth
        do {
            try await authService.linkAnonymousAccount(email: email, password: password)

            // Step 2: Update user profile
            try await userService.updateCurrentUser(isLinking: true, newName: name)

            Log.info("Anonymous account linked")
        } catch {
            // TODO: Surface error message to user without changing auth state, they are already authenticated here, linking wont change that
            Log.error("Anonymous account linking failed")
        }
    }

    // TODO: handle failures and error states
    func deleteAccount() async throws {
        // Delete all user's routines
        if let routineIds = userService.user.routines {
            for routineId in routineIds {
                try await routineService.deleteRoutine(routineId)
            }
        }

        // Delete user profile
        try await userService.deleteUser()

        // Delete auth account
        try await authService.deleteAccount()

        // Clear caches
        try? userService.clearCachedProfileImage()
        Log.info("Account deleted")
    }

    // MARK: - Routine Operations (Require Coordination)

    /// Creates a routine and adds it to the user's routine list
    /// ⚠️ This is the ONLY way to properly create a routine
    func createRoutine(_ routine: Routine) async throws {
        var routineSaved = false

        do {
            // Step 1: Save routine to Firestore
            // TODO: Refactor naming to avoid confusion
            try await routineService.createRoutine(routine)

            // Step 2: Add to user's routine list
            try await userService.addRoutineId(routine.id)

            Log.info("Routine created: \(routine.name)")
        } catch {
            // Rollback silently if any step fails
            Log.warning("Rolling back routine save")
            try? await routineService.deleteRoutine(routine.id)
            throw error
        }
    }

    /// Deletes a routine and removes it from the user's routine list
    /// ⚠️ This is the ONLY way to properly delete a routine
    func deleteRoutine(_ routineId: String) async throws {
        var userUpdated = false

        do {
            // Step 1: Remove from user list first
            try await userService.removeRoutineId(routineId)
            userUpdated = true

            // Step 2: Delete the routine
            try await routineService.deleteRoutine(routineId)

            Log.info("Routine deleted: \(routineId)")
        } catch {
            // Rollback if step 2 failed
            if userUpdated {
                Log.warning("Rolling back user update")
                try? await userService.addRoutineId(routineId)
            }
            throw error
        }
    }

    /// Deletes multiple routines (for swipe-to-delete)
    func deleteRoutines(at indexSet: IndexSet, from routines: [Routine]) async throws {
        let routinesToDelete = indexSet.map { routines[$0] }

        for routine in routinesToDelete {
            try await deleteRoutine(routine.id)
        }
    }
}
