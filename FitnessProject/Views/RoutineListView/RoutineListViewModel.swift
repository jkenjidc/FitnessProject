//
//  RoutineListViewModel.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 10/7/24.
//

import Foundation

extension RoutineListView {
    @MainActor
    @Observable class ViewModel {
        var hasHitLimit = false
        var showRoutineLimitAlert = false
        var presentDialogueView = false
        var selectedRoutine = Routine()
        
        func deleteRoutine(at index: IndexSet) async {
            do {
                try await DataManager.shared.deleteRoutine(at: index)
            } catch {
                print(error)
            }
        }
        
        func presentRoutineDetailCard(routine: Routine) {
            selectedRoutine = routine
            presentDialogueView = true
        }
        
    }
    
    
    
}
