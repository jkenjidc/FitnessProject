//
//  ExerciseV2.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 4/9/25.
//

import Foundation

public struct ExerciseV2: Identifiable, Sendable {
    public let id: String
    public let name: String
    public let bodyPart: String
    public let equipment: String
    public let gifUrl: URL
    public let target: String
    public let secondaryMuscles: [String]
    public let instructions: [String]
    
    public init(
        id: String,
        name: String,
        bodyPart: String,
        equipment: String,
        gifUrl: URL,
        target: String,
        secondaryMuscles: [String],
        instructions: [String]
    ) {
        self.id = id
        self.name = name
        self.bodyPart = bodyPart
        self.equipment = equipment
        self.gifUrl = gifUrl
        self.target = target
        self.secondaryMuscles = secondaryMuscles
        self.instructions = instructions
    }
}


// MARK: Conversions

extension ExerciseV2 {
    init (from dto: ExerciseV2DTO)  {
        self.id = dto.id
        self.name = dto.name
        self.bodyPart = dto.bodyPart
        self.equipment = dto.equipment
        self.gifUrl = dto.gifUrl
        self.target = dto.target
        self.secondaryMuscles = dto.secondaryMuscles
        self.instructions = dto.instructions
    }
}
