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
        
        func signIn(email: String, password: String) async throws {
            guard !email.isEmpty, !password.isEmpty else {
                print("No email or password found.")
                return
            }
            do {
                try await AuthManager.shared.signInUser(email: email, password: password)
            } catch {
                print(error)
            }

        }
    }
}
