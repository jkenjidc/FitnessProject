//
//  RoutineService.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 10/21/25.
//
import Foundation
import FirebaseFirestore

@Observable
class RoutineService {
    var routines: [Routine] = []
    var networkState: FirebaseCallState = .loading
    private let routineCollection = Firestore.firestore().collection("routines")
    var routinesOfTheDay: [Routine] {
        routines.routinesOfTheDay
    }

    func loadRoutines(routineIds: [String]) async throws {
        // Early return for empty routine list
        guard !routineIds.isEmpty else {
            routines = []
            networkState = .loaded
            return
        }

        let snapshot = try await routineCollection
            .whereField("id", in: routineIds)
            .getDocuments()

        let loadedRoutines = snapshot.documents.compactMap { document in
            do {
                return try document.data(as: Routine.self)
            } catch {
                Log.error("Failed to parse routine \(document.documentID): \(error)")
                networkState = .error(error)
                return nil
            }
        }

        self.routines = loadedRoutines
        networkState = .loaded
        Log.info("Loaded \(loadedRoutines.count) of \(routineIds.count) routines")
    }

    func createRoutine(routine: Routine) async throws {
        //Adds the routine to the apps's list of local routines
        routines.append(routine)

        //Sends the routine and user to the firestore DB
        try await updateRoutine(routine: routine)
        Log.info("Routine: \(routine.name) was created successfully")

    }

    func updateRoutine(routine: Routine) async throws {
        //save any changes to any existing instance of the same routine locally
        if let index = routines.firstIndex(where: {$0.id == routine.id}){
            routines[index] = routine
        }
        //save to remote
        try routineCollection.document(routine.id).setData(from: routine, merge: true)
        Log.info("Routine: \(routine.name) was updated successfully")
        Log.info("Info: \(routine.exercises)")

    }

    func deleteRoutine(at indexSet: IndexSet) async throws {
        let routineIdsToDelete = indexSet.map { routines[$0] }.map { $0.id }

        // Store original state for rollback
        let originalRoutines = routines

        do {
            // 1. Delete from Firestore first
            for routineId in routineIdsToDelete {
                try await routineCollection.document(routineId).delete()
            }

            // 2. Update local state after successful Firestore operations
            routines.removeAll { routine in
                routineIdsToDelete.contains(routine.id)
            }

            Log.info("Successfully deleted \(routineIdsToDelete.count) routines")

        } catch {
            // Rollback local changes on failure
            routines = originalRoutines

            Log.error("Failed to delete routines, rolled back changes: \(error)")
            throw error
        }
    }
}
