//
//  SignInViewModel.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/24/24.
//

import Foundation

extension SignInScreen {
    @Observable
    class ViewModel {
        var email = ""
        var password = ""
        var showForgotPasswordField = false
        var alertTitle = ""
        var alertMessage = ""
        var showAlert = false
        var invalidInputs: Bool {
            return email.isEmpty && password.isEmpty
        }
    }
}
