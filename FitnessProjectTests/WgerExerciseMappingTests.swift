//
//  WgerExerciseMappingTests.swift
//  FitnessProjectTests
//
//  Created by Kenji Dela Cruz on 10/15/26.
//

import Foundation
import Testing
@testable import FitnessProject

struct WgerExerciseMappingTests {
    /// Trimmed from a real `exerciseinfo` response: an English + Ukrainian exercise and a German-only one.
    let samplePage = """
    {
        "count": 2,
        "next": "https://wger.de/api/v2/exerciseinfo/?language=2&limit=2&offset=2",
        "previous": null,
        "results": [
            {
                "id": 9,
                "category": { "id": 10, "name": "Abs" },
                "muscles": [{ "id": 11, "name": "Biceps femoris", "name_en": "Hamstrings", "is_front": false }],
                "muscles_secondary": [
                    { "id": 10, "name": "Quadriceps femoris", "name_en": "Quads", "is_front": true },
                    { "id": 3, "name": "Serratus anterior", "name_en": "", "is_front": true }
                ],
                "equipment": [{ "id": 10, "name": "Kettlebell" }],
                "images": [
                    { "id": 1, "image": "https://wger.de/media/a.png", "is_main": false },
                    { "id": 2, "image": "https://wger.de/media/b.png", "is_main": true }
                ],
                "translations": [
                    { "id": 5230, "name": "Махи гирею", "description": "<p>Інше</p>", "language": 15 },
                    { "id": 345, "name": " 2 Handed Kettlebell Swing ", "description": "<ol><li>Stand &amp; hinge.</li>\\n<li><strong>Swing</strong> up.</li></ol>", "language": 2 }
                ]
            },
            {
                "id": 10,
                "category": { "id": 8, "name": "Arms" },
                "muscles": [],
                "muscles_secondary": [],
                "equipment": [{ "id": 7, "name": "none (bodyweight exercise)" }],
                "images": [],
                "translations": [
                    { "id": 1, "name": "Nur Deutsch", "description": "<p>Text</p>", "language": 1 }
                ]
            }
        ]
    }
    """

    func decode(_ json: String) throws -> WgerExercisePage {
        try JSONDecoder().decode(WgerExercisePage.self, from: Data(json.utf8))
    }

    @Test func mapsEnglishExercise() throws {
        let page = try decode(samplePage)
        #expect(page.count == 2)
        #expect(page.next != nil)

        let exercises = page.results.compactMap(ExerciseV2.init)
        #expect(exercises.count == 1, "Exercises without an English translation are skipped")

        let swing = try #require(exercises.first)
        #expect(swing.id == "9")
        #expect(swing.name == "2 Handed Kettlebell Swing")
        #expect(swing.bodyPart == "Abs")
        #expect(swing.target == "Hamstrings")
        #expect(swing.secondaryMuscles == ["Quads", "Serratus anterior"])
        #expect(swing.equipment == "Kettlebell")
        #expect(swing.imageURL?.absoluteString == "https://wger.de/media/b.png")
        #expect(swing.instructions == ["Stand & hinge.", "Swing up."])
    }

    @Test func bodyweightAndMissingFieldsFallBack() throws {
        let page = try decode(samplePage.replacingOccurrences(of: "\"language\": 1 }", with: "\"language\": 2 }"))
        let exercise = try #require(page.results.compactMap(ExerciseV2.init).first { $0.id == "10" })

        #expect(exercise.equipment == "Body weight")
        #expect(exercise.target == "—")
        #expect(exercise.imageURL == nil)
        #expect(exercise.instructions == ["Text"])
    }

    @Test(arguments: [
        ("<p>One</p><p>Two</p>", ["One", "Two"]),
        ("<ul><li>A</li></ul><p>ignored</p>", ["A"]),
        ("Plain text", ["Plain text"]),
        ("", [])
    ])
    func htmlToInstructionSteps(html: String, expected: [String]) {
        #expect(html.htmlToInstructionSteps() == expected)
    }
}
