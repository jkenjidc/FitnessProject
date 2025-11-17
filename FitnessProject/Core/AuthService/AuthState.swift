//
//  AuthState.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 11/16/25.
//

import Foundation
enum AuthState {
    case authenticating                     // Operation in progress
    case unauthenticated                    // Checked, no user (normal)
    case authenticated(AuthDataResultModel) // User logged in
    case error(AuthError)                   // Auth operation failed
}
