//
//  WelcomeViewModel.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/25/24.
//

import Foundation

@MainActor
extension WelcomeView {
    @Observable
    class ViewModel {
        var showGuestModeAlert = false
        func signInAnonymously() async throws {
            let authDataResult =  try await AuthManager.shared.signInAnonymously()
            try await DataManager.shared.createNewUser(auth: authDataResult)
            
        }
    }
}
