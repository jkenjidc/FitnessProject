//
//  WgerExerciseDTO.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 10/15/26.
//

import Foundation

/// One page of results from `GET /api/v2/exerciseinfo/`.
struct WgerExercisePage: Decodable {
    let count: Int
    let next: URL?
    let results: [WgerExerciseInfoDTO]
}

/// One result from `GET /api/v2/exerciseinfo/`.
struct WgerExerciseInfoDTO: Decodable {
    let id: Int
    let category: Category
    let muscles: [Muscle]
    let musclesSecondary: [Muscle]
    let equipment: [Equipment]
    let images: [Image]
    let translations: [Translation]

    enum CodingKeys: String, CodingKey {
        case id, category, muscles, equipment, images, translations
        case musclesSecondary = "muscles_secondary"
    }

    struct Category: Decodable {
        let name: String
    }

    struct Muscle: Decodable {
        let name: String
        let nameEn: String

        enum CodingKeys: String, CodingKey {
            case name
            case nameEn = "name_en"
        }

        var displayName: String {
            nameEn.isEmpty ? name : nameEn
        }
    }

    struct Equipment: Decodable {
        let name: String
    }

    struct Image: Decodable {
        let image: URL
        let isMain: Bool

        enum CodingKeys: String, CodingKey {
            case image
            case isMain = "is_main"
        }
    }

    struct Translation: Decodable {
        let name: String
        let description: String
        let language: Int
    }
}
