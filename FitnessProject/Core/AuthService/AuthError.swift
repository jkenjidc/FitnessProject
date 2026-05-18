//
//  AuthError.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 11/8/24.
//

import Foundation
import FirebaseAuth

enum AuthError: LocalizedError, Equatable {
    case emailInUse
    case invalidEmail
    case weakPassword
    case userNotFound
    case wrongPassword
    case networkError
    case tooManyRequests
    case invalidCredentials
    case userDisabled
    case unknownError(Error)

    static let defaultMessage = "Auth error description cannot be read"
    var errorDescription: String? {
        switch self {
        case .emailInUse:
            return "This email is already in use. Please try another one."
        case .invalidEmail:
            return "Please enter a valid email address."
        case .weakPassword:
            return "Password must be at least 6 characters long."
        case .userNotFound:
            return "Account not found. Please check your email or sign up."
        case .wrongPassword:
            return "Incorrect password. Please try again."
        case .networkError:
            return "Network error. Please check your connection."
        case .tooManyRequests:
            return "Too many attempts. Please try again later."
        case .invalidCredentials:
            return "Invalid information. Please check your email or password."
        case .userDisabled:
            return "This account has been disabled. Please contact support."
        case .unknownError(let error):
            return error.localizedDescription
        }
    }

    static func == (lhs: AuthError, rhs: AuthError) -> Bool {
        switch (lhs, rhs) {
        case (.emailInUse, .emailInUse),
            (.invalidEmail, .invalidEmail),
            (.weakPassword, .weakPassword),
            (.userNotFound, .userNotFound),
            (.wrongPassword, .wrongPassword),
            (.networkError, .networkError),
            (.tooManyRequests, .tooManyRequests),
            (.invalidCredentials, .invalidCredentials),
            (.userDisabled, .userDisabled):
            return true
        case let (.unknownError(error1), .unknownError(error2)):
            return error1.localizedDescription == error2.localizedDescription
        default:
            return false
        }
    }

    init(_ error: Error) {
        let nsError = error as NSError
        self = switch nsError.code {
        case AuthErrorCode.emailAlreadyInUse.rawValue:
                .emailInUse
        case AuthErrorCode.invalidEmail.rawValue:
                .invalidEmail
        case AuthErrorCode.weakPassword.rawValue:
                .weakPassword
        case AuthErrorCode.userNotFound.rawValue:
                .userNotFound
        case AuthErrorCode.wrongPassword.rawValue:
                .wrongPassword
        case AuthErrorCode.networkError.rawValue:
                .networkError
        case AuthErrorCode.tooManyRequests.rawValue:
                .tooManyRequests
        case AuthErrorCode.invalidCredential.rawValue:
                .invalidCredentials
        case AuthErrorCode.userDisabled.rawValue:
                .userDisabled
        default:
                .unknownError(error)
        }
    }
}
