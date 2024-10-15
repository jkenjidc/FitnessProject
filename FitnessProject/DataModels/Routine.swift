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
    var datesDone: [String:Int] = [:]
    var exercises: [Exercise] = []
    
    static func == (lhs: Routine, rhs: Routine) -> Bool {
        return lhs.id == rhs.id
    }
    
    init() {
        id = UUID().uuidString
        name = ""
        daysToDo = []
        datesDone = [:]
        exercises = []
    }
    init(id: String = UUID().uuidString, name: String, daysToDo: [String], datesDone: [String:Int], exercises: [Exercise]) {
        self.id = id
        self.name = name
        self.daysToDo = daysToDo
        self.datesDone = datesDone
        self.exercises = exercises
    }
    static let dateString = Date.now.formatted(date: .numeric, time: .omitted)
    
    static let example = [Routine(name: "Routine 1", daysToDo: ["monday","thursday"], datesDone: [dateString : 4, dateString : 5], exercises: []),
                          Routine(name: "Routine 2", daysToDo: ["monday","thursday"], datesDone: [dateString : 4, dateString : 5], exercises: [Exercise.example, Exercise.example, Exercise.example]),
                          Routine(name: "Routine 3", daysToDo: ["monday","thursday"], datesDone: [dateString : 4, dateString : 6], exercises: [])]
    
    
}
