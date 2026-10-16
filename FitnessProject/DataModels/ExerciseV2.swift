//
//  ExerciseV2.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 4/9/25.
//

import Foundation

public struct ExerciseV2: Identifiable, Sendable, Codable {
    public let id: String
    public let name: String
    public let bodyPart: String
    public let equipment: String
    public let imageURL: URL?
    public let target: String
    public let secondaryMuscles: [String]
    public let instructions: [String]

    var accessoryLabels: [String] {
        return [bodyPart, target, equipment]
    }

    public init(
        id: String,
        name: String,
        bodyPart: String,
        equipment: String,
        imageURL: URL?,
        target: String,
        secondaryMuscles: [String],
        instructions: [String]
    ) {
        self.id = id
        self.name = name
        self.bodyPart = bodyPart
        self.equipment = equipment
        self.imageURL = imageURL
        self.target = target
        self.secondaryMuscles = secondaryMuscles
        self.instructions = instructions
    }
}


// MARK: Conversions

extension ExerciseV2 {
    /// Maps a wger exercise, returning `nil` when it has no English translation.
    init?(from dto: WgerExerciseInfoDTO) {
        guard let translation = dto.translations.first(where: { $0.language == WgerRequest.englishLanguageId }) else {
            return nil
        }

        let equipmentName = dto.equipment.first?.name ?? ""
        let isBodyWeight = equipmentName.isEmpty || equipmentName.lowercased().hasPrefix("none")

        self.id = String(dto.id)
        self.name = translation.name.trimmingCharacters(in: .whitespacesAndNewlines)
        self.bodyPart = dto.category.name
        self.equipment = isBodyWeight ? "Body weight" : equipmentName
        self.imageURL = (dto.images.first(where: \.isMain) ?? dto.images.first)?.image
        self.target = dto.muscles.first?.displayName ?? "—"
        self.secondaryMuscles = dto.musclesSecondary.map(\.displayName)
        self.instructions = translation.description.htmlToInstructionSteps()
    }

    static var mock: ExerciseV2 {
        return ExerciseV2(
            id: "91",
            name: "Crunches",
            bodyPart: "Abs",
            equipment: "Body weight",
            imageURL: URL(string: "https://wger.de/media/exercise-images/91/Crunches-1.png"),
            target: "Abs",
            secondaryMuscles: ["Obliquus externus abdominis"],
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
