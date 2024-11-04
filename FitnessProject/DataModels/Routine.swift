//
//  Routine.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/10/24.
//

import Foundation
import FirebaseFirestore

struct Routine: Identifiable, Codable, Hashable, Equatable {
    var id = UUID().uuidString
    var description: String = ""
    var name: String = ""
    var daysToDo: [String] = []
    var exercises: [Exercise] = []
    
    static func == (lhs: Routine, rhs: Routine) -> Bool {
        return lhs.id == rhs.id
    }
    
    init() {
        id = UUID().uuidString
        name = ""
        daysToDo = []
        exercises = []
    }
    init(id: String = UUID().uuidString, name: String, daysToDo: [String], exercises: [Exercise]) {
        self.id = id
        self.name = name
        self.daysToDo = daysToDo
        self.exercises = exercises
    }
    static let dateString = Date.now.formatted(date: .numeric, time: .omitted)
    
    static let example = [Routine(name: "Routine 1", daysToDo: ["monday","thursday"], exercises: [Exercise.example, Exercise.example, Exercise.example]),
                          Routine(name: "Routine 2", daysToDo: ["monday","thursday"], exercises: [Exercise.example, Exercise.example, Exercise.example]),
                          Routine(name: "Routine 3", daysToDo: ["monday","thursday"], exercises: [])]
    
    
}
