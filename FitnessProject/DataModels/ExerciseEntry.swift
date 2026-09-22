//
//  ExerciseEntry.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/10/24.
//

import Foundation
struct ExerciseEntry: Identifiable, Codable, Hashable {
    // for view identity
    var id = UUID().uuidString
    // for exercise db reference
    var exerciseId: String
    var name: String = ""
    var sets: [ExerciseSet] = []

    func getSetIndex(exerciseSet: ExerciseSet) -> String {
        return String((sets.firstIndex(where: { $0.id == exerciseSet.id }) ?? 0) + 1)
    }

    mutating func deleteSet(exerciseSet: ExerciseSet) {
        sets.removeAll(where: { $0.id == exerciseSet.id })
    }

    init(from catalogExercise: ExerciseV2, sets: [ExerciseSet] = []) {
        self.exerciseId = catalogExercise.id
        self.name = catalogExercise.name
        self.sets = sets
    }

    static let example = ExerciseEntry(from: .mock, sets: ExerciseSet.example)
}
