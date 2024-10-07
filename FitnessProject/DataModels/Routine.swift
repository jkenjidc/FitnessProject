//
//  Routine.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/10/24.
//

import Foundation

struct Routine: Identifiable, Codable, Hashable, Equatable {
    var id = UUID().uuidString
    var description: String = ""
    var name: String = ""
    var daysToDo: [String] = []
    var datesDone: [Date] = []
    var exercises: [Exercise] = []
    
    static func == (lhs: Routine, rhs: Routine) -> Bool {
        return lhs.id == rhs.id
    }
    
    init() {
        id = UUID().uuidString
        name = ""
        daysToDo = []
        datesDone = []
        exercises = []
    }
    init(id: String = UUID().uuidString, name: String, daysToDo: [String], datesDone: [Date], exercises: [Exercise]) {
        self.id = id
        self.name = name
        self.daysToDo = daysToDo
        self.datesDone = datesDone
        self.exercises = exercises
    }
    
    static let example = [Routine(name: "Routine 1", daysToDo: ["monday","thursday"], datesDone: [.now, .now + 1], exercises: []),Routine(name: "Routine 2", daysToDo: ["monday","thursday"], datesDone: [.now, .now + 3], exercises: []),Routine(name: "Routine 3", daysToDo: ["monday","thursday"], datesDone: [.now, .now + 3], exercises: [])]
    
    
}
