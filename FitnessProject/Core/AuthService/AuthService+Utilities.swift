//
//  AuthService+Utilities.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 11/11/25.
//

import Foundation
import FirebaseAuth

extension AuthService {
    func handleAuthError(_ error: Error) {
        let error  = AuthError(error)

        if case .unknownError(let error) = error {
            Log.error("Unhandled Firebase Error Code: \(error)")
        } else {
            Log.error("Firebase error: \(error)")
        }

        authState = .error(error)
    }
}
