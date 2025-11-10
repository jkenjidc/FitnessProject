//
//  RoutineListViewModel.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 10/7/24.
//

import Foundation
import SwiftUI

extension RoutinesScreen {
    @Observable class ViewModel {
        var hasHitLimit = false
        var showRoutineLimitAlert = false
        var presentDialogueView = false
        var selectedRoutine = Routine()
        var dataManager = DataManager.shared
        var weekdayIndex = Calendar.current.component(.weekday, from: Date())
        
        var currentDay: String {
            let formatter = DateFormatter()
            return String(formatter.weekdaySymbols[weekdayIndex - 1])
        }
        
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
