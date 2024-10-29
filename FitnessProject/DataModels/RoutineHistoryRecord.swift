//
//  RoutineHistoryRecord.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 10/29/24.
//

import Foundation

struct RoutineHistoryRecord: Codable, Hashable, Equatable, Identifiable {
    var id = UUID().uuidString
    var dateDone = Date.now
    var nameOfRoutine: String
    var durationOfRoutine: Int
    var exercises: [Exercise]
    
    init(nameOfRoutine: String, durationOfRoutine: Int, exercises: [Exercise]) {
        self.nameOfRoutine = nameOfRoutine
        self.durationOfRoutine = durationOfRoutine
        self.exercises = exercises
    }
}
