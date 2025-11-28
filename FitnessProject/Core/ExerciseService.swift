//
//  ExercisesServices.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 8/8/25.
//

import SwiftUI
import Observation

@Observable
class ExerciseService {
    var networkState: NetworkCallState<[ExerciseV2]> = .loading
    var searchQuery: String = ""
    var selectedBodyPart: String?
    var selectedEquipment: String?

    var exercises: [ExerciseV2] {
        switch networkState {
        case .loaded(let exercises):
            return exercises
        default:
            return []
        }
    }

    var filteredExercises: [ExerciseV2] {
        exercises.filter { exercise in
            let bodyPartMatches = selectedBodyPart == nil || exercise.bodyPart == selectedBodyPart

            let selectedEquipment = selectedEquipment == nil || exercise.equipment == selectedEquipment

            let searchMatches = searchQuery.isEmpty || exercise.name.lowercased().contains(searchQuery.lowercased())

            return bodyPartMatches && selectedEquipment && searchMatches
        }
    }

    var bodyPartOptions: [String] {
        exercises.uniqueValues(for: .bodyPart)
    }

    var equipmentOptions: [String] {
        exercises.uniqueValues(for: .equipment)
    }

    func fetchExercises() async {
        Log.info("Fetching exercises data....")
        do {
            // First, try to use cache if it exists and is valid
            if let cachedExercises = URLCache.shared.cachedResponse(for: ExerciseV2Request.request()),
               let expirationDate = cachedExercises.userInfo?["expirationDate"] as? Date,
               Date() < expirationDate {

                do {
                    try fetchCache(cachedExercises)
                    return // Success with cache, exit early
                } catch {
                    Log.error("Cache fetch failed, falling back to network: \(error.localizedDescription)")
                }
            }

            // If no valid cache or cache fetch failed, fetch from network
            try await fetchAndCacheExercises()

        } catch let exerciseError as ExerciseServiceError {
            Log.error("Exercise service error: \(exerciseError.errorDescription)")
            networkState = .error(exerciseError)
        } catch {
            Log.error("Unexpected error fetching exercises: \(error.localizedDescription)")
            networkState = .error(error)
        }
    }

    func fetchAndCacheExercises() async throws {
        let (data, response) = try await URLSession.shared.data(for: ExerciseV2Request.request())

        // Validate the response
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ExerciseServiceError.invalidResponse
        }

        guard httpResponse.statusCode == 200 else {
            throw ExerciseServiceError.httpError(statusCode: httpResponse.statusCode)
        }

        // Cache the successful response
        let initialCache = CachedURLResponse(
            response: httpResponse,
            data: data,
            storagePolicy: .allowed
        )
        var userInfo = initialCache.userInfo ?? [:]
        userInfo["expirationDate"] = Date.threeMonthsFromToday()
        let cachedResponse = CachedURLResponse(
            response: initialCache.response,
            data: initialCache.data,
            userInfo: userInfo,
            storagePolicy: initialCache.storagePolicy
        )

        URLCache.shared.storeCachedResponse(cachedResponse, for: ExerciseV2Request.request())

        do {
            let decodedResponse = try JSONDecoder().decode([ExerciseV2DTO].self, from: data)
            networkState = .loaded(decodedResponse.map(ExerciseV2.init))
            Log.info("Successfully fetched and cached \(exercises.count) exercises")
        } catch {
            throw ExerciseServiceError.networkDecodingFailed(underlyingError: error)
        }
    }

    func fetchCache(_ cachedResponse: CachedURLResponse) throws {
        do {
            let decodedResponse = try JSONDecoder().decode([ExerciseV2DTO].self, from: cachedResponse.data)
            networkState = .loaded(decodedResponse.map(ExerciseV2.init))
            Log.info("Successfully loaded \(exercises.count) exercises from cache")
        } catch {
            throw ExerciseServiceError.cacheCorrupted
        }
    }
}
