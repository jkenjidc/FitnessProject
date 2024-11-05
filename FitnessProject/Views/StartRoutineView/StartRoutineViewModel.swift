//
//  StartRoutineViewModel.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 10/10/24.
//

import Foundation
import SwiftUI


extension StartRoutineView {
    @Observable class ViewModel {
        var dataManager = DataManager.shared
        
        var weekdayIndex = Calendar.current.component(.weekday, from: Date())
        var currentDay: String {
            let formatter = DateFormatter()
            return String(formatter.weekdaySymbols[weekdayIndex - 1])
        }
        
        var routinesForTheDay: [Routine] {
            return dataManager.routines.filter({ $0.daysToDo.contains(currentDay)})
        }
        
    }
}
