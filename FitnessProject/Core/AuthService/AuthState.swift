//
//  AuthState.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 11/16/25.
//

import Foundation
enum AuthState {
    case unauthenticated                    // Checked, no user (normal)
    case authenticated(AuthData)            // User logged in
    case error(AuthError)                   // Auth operation failed
}
