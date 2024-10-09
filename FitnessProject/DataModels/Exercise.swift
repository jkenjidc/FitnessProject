//
//  File.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/10/24.
//

import Foundation
import SwiftUI

struct Exercise: Identifiable, Codable, Hashable {
    var id = UUID().uuidString
    var name: String = ""
    var description: String? = ""
    var stats: Stats = Stats.example
    var sets: [ExerciseSet] = []
    
    func getSetIndex(exerciseSet: ExerciseSet) -> String {
        return String ((sets.firstIndex(where: { $0.id == exerciseSet.id }) ?? 0) + 1)
    }
    
   mutating func deleteSet(exerciseSet: ExerciseSet) {
           sets.removeAll(where: { $0.id == exerciseSet.id})
    }
    
    init() {
        
    }
    
    init(name: String, sets: [ExerciseSet]) {
        self.name = name
        self.sets = sets
    }
    
    static let example = Exercise(name: "Test 1", sets: ExerciseSet.example)
}
