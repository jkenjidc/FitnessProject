//
//  Routine.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/10/24.
//

import Foundation

struct Routine: Identifiable, Codable, Hashable {
    var id = UUID().uuidString
    let name: String
    let daysToDo: [String]
    let datesDone: [Date]
    let exercises: [Exercise]
    
    init(id: String = UUID().uuidString, name: String, daysToDo: [String], datesDone: [Date], exercises: [Exercise]) {
        self.id = id
        self.name = name
        self.daysToDo = daysToDo
        self.datesDone = datesDone
        self.exercises = exercises
    }
    
}
