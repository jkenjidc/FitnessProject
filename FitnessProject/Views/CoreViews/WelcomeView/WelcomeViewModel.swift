//
//  WelcomeViewModel.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/25/24.
//

import Foundation

extension WelcomeView {
    @Observable
    class ViewModel {
        var showGuestModeAlert = false
        func signInAnonymously() async {
            do {
                let authDataResult =  try await AuthManager.shared.signInAnonymously()
                let user = CurrentUser(auth: authDataResult)
                try await DataManager.shared.createUser(user: user)
                try await DataManager.shared.loadUser()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
