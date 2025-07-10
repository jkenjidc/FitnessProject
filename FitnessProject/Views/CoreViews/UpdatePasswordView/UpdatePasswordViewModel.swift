//
//  UpdatePasswordViewModel.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 10/29/24.
//

import Foundation
import Observation

extension UpdatePasswordView {
    @Observable class ViewModel {
        var newPassword = ""
        var confirmPassword = ""
        var passwordsMatch = true
        var changeSucessful = false
        func verifyPasswordMatch() {
            if !confirmPassword.isEmpty {
                passwordsMatch = newPassword == confirmPassword
            }
        }
        
        func changePassword() async {
            do {
                try await AuthManager.shared.updatePassword(password: newPassword)
                changeSucessful = true
                newPassword = ""
                confirmPassword = ""
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
