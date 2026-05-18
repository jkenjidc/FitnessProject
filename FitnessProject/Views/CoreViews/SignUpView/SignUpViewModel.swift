//
//  SignUpViewModel.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/23/24.
//

import Foundation

extension SignUpScreen {
    @Observable class ViewModel {
        var email = ""
        var password = ""
        var passwordConfirmation = ""
        var name = ""
        var passwordsMatch = true
        var alertTitle = ""
        var alertMessage = ""
        var showAlert = false
        var validSubmission: Bool {
            return !email.isEmpty && !name.isEmpty && !passwordConfirmation.isEmpty && !passwordConfirmation.isEmpty && passwordsMatch
        }

        func verifyPasswordMatch() {
            if !passwordConfirmation.isEmpty {
                passwordsMatch = password == passwordConfirmation
            }
        }
    }
}
