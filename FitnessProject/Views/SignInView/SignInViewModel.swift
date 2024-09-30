//
//  SignInViewModel.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/24/24.
//

import Foundation

extension SignInView {
    @Observable
    class ViewModel {
        var email = ""
        var password = ""
        var showForgotPasswordField = false
        var invalidInputs: Bool {
            return email.isEmpty && password.isEmpty
        }
        
        func signIn() async throws {
            try await AuthManager.shared.signInUser(email: email, password: password)
            try await DataManager.shared.loadUser()
        }
    }
}
