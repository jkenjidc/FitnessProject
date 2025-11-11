//
//  AuthService+Utilities.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 11/11/25.
//

import Foundation
import FirebaseAuth

extension AuthService {
    enum AuthState {
        case idle                               // Haven't checked yet
        case unauthenticated                    // Checked, no user (normal)
        case authenticating                     // Operation in progress
        case authenticated(AuthDataResultModel) // User logged in
        case error(AuthError)                   // Auth operation failed
    }

    func handleAuthError(_ error: Error) -> AuthError {
        let nsError = error as NSError

        // Print the error code to debug
        Log.info("Firebase Error Code: \(nsError.code)")

        switch nsError.code {
        case AuthErrorCode.emailAlreadyInUse.rawValue:
            return .emailInUse
        case AuthErrorCode.invalidEmail.rawValue:
            return .invalidEmail
        case AuthErrorCode.weakPassword.rawValue:
            return .weakPassword
        case AuthErrorCode.userNotFound.rawValue:
            return .userNotFound
        case AuthErrorCode.wrongPassword.rawValue:
            return .wrongPassword
        case AuthErrorCode.networkError.rawValue:
            return .networkError
        case AuthErrorCode.tooManyRequests.rawValue:
            return .tooManyRequests
        case AuthErrorCode.invalidCredential.rawValue:
            return .invalidCredentials
        case AuthErrorCode.userDisabled.rawValue:
            return .userDisabled
        default:
            print("Unhandled error code: \(nsError.code)")
            return .unknownError(error)
        }
    }

}
