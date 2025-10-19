//  ExerciseDTO.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 4/9/25.
//

import Foundation

struct ExerciseV2DTO: Decodable {
    let bodyPart: String
    let equipment: String
    let id: String
    let name: String
    let target: String
    let secondaryMuscles: [String]
    let instructions: [String]
    let difficulty: String
    let category: String
}
