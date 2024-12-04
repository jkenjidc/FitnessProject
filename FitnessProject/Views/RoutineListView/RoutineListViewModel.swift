//
//  RoutineListViewModel.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 10/7/24.
//

import Foundation

extension RoutineListView {
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
        
        var routinesForTheDay: [Routine] {
            return dataManager.routines.filter({ $0.daysToDo.contains(currentDay)})
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
