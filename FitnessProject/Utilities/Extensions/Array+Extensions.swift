//
//  Array+Extensions.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 7/27/25.
//

import Foundation

extension Array where Element == ExerciseV2 {
    enum ExerciseProperty {
        case bodyPart
        case equipment
        case target
        case secondaryMuscles
    }

    func uniqueValues(for property: ExerciseProperty) -> [String] {
        switch property {
        case .bodyPart:
            return Set(self.map { $0.bodyPart }).sorted()
        case .equipment:
            return Set(self.map { $0.equipment }).sorted()
        case .target:
            return Set(self.map { $0.target }).sorted()
        case .secondaryMuscles:
            return Set(self.flatMap { $0.secondaryMuscles }).sorted()
        }
    }
}
