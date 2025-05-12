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

    static var mock: ExerciseV2 {
        return ExerciseV2(
            id: "0001",
            name: "3/4 sit-up",
            bodyPart: "waist",
            equipment: "body weight",
            gifUrl: URL(string: "https://v2.exercisedb.io/image/VHyPWC2GuuP6en")!,
            target: "abs",
            secondaryMuscles: ["hip flexors", "lower back"],
            instructions: [
                "Lie flat on your back with your knees bent and feet flat on the ground.",
                "Place your hands behind your head with your elbows pointing outwards.",
                "Engaging your abs, slowly lift your upper body off the ground, curling forward until your torso is at a 45-degree angle.",
                "Pause for a moment at the top, then slowly lower your upper body back down to the starting position.",
                "Repeat for the desired number of repetitions."
            ]
        )
    }

    static var mockList: [ExerciseV2] {
        return [mock]
    }
}
