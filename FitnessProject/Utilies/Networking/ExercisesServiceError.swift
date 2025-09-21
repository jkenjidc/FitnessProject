//
//  ExercisesServiceError.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 8/18/25.
//

import Foundation

enum ExerciseServiceError: Error, LocalizedError {
    case invalidResponse
    case httpError(statusCode: Int)
    case networkDecodingFailed(underlyingError: Error)
    case cacheCorrupted
    case networkUnavailable

    var errorDescription: String {
        switch self {
        case .invalidResponse:
            return "Invalid server response received"
        case .httpError(let statusCode):
            return "HTTP request failed with status code: \(statusCode)"
        case .networkDecodingFailed(let error):
            return "Failed to decode exercises from network response: \(error)"
        case .cacheCorrupted:
            return "Cached exercise data is corrupted and cannot be loaded"
        case .networkUnavailable:
            return "Network connection is unavailable"
        }
    }
}
