//
//  File.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/10/24.
//

import Foundation

struct Exercise: Identifiable, Codable, Hashable {
    var id = UUID().uuidString
    let name: String
    let description: String?
    let stats: Stats
    let sets: [ExerciseSet]
}
