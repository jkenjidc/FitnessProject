//
//  ExerciseSet.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/10/24.
//

import Foundation

struct ExerciseSet: Identifiable, Hashable, Codable {
    var id = UUID().uuidString
    var weight: Double
    var reps: Int
    
    init(id: String = UUID().uuidString, weight: Double, reps: Int) {
        self.id = id
        self.weight = weight
        self.reps = reps
    }
}
