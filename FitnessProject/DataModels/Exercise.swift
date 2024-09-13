//
//  File.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/10/24.
//

import Foundation

struct Exercise: Identifiable, Codable, Hashable {
    var id = UUID().uuidString
    var name: String = ""
    var description: String? = ""
    var stats: Stats = Stats.example
    var sets: [ExerciseSet] = []
}
