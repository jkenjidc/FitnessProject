//
//  SignUpViewModel.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/23/24.
//

import Foundation

extension SignUpView {
    @Observable
    class ViewModel {
        var email = ""
        var password = ""
        var passwordConfirmation = ""
        var name = ""
        var passwordsMatch = true
        var validSubmission: Bool {
            return !email.isEmpty && !name.isEmpty && !passwordConfirmation.isEmpty && !passwordConfirmation.isEmpty && passwordsMatch
        }
        
        func verifyPasswordMatch() {
            if !passwordConfirmation.isEmpty {
                passwordsMatch = password == passwordConfirmation
            }
        }
        
        func signUp(email: String, password: String) async throws {
            guard !email.isEmpty, !password.isEmpty else {
                print("No email or password found.")
                return
            }
            do {
                try await AuthManager.shared.createUser(email: email, password: password)
            } catch {
                print(error)
            }

        }
        
        
        
        
    }
}
