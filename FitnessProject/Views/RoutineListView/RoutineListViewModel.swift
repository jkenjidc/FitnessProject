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
        
        func deleteRoutine(at index: IndexSet) async {
            do {
                try await DataManager.shared.deleteRoutine(at: index)
            } catch {
                print(error)
            }
        }
        
    }
    
    
    
}
