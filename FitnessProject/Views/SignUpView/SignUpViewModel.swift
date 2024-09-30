//
//  SignUpViewModel.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/23/24.
//

import Foundation

extension SignUpView {
    @Observable class ViewModel {
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
        
        func signUp() async throws {
            let user = try await AuthManager.shared.createUser(email: email, password: password)
            try await DataManager.shared.createNewUser(user: CurrentUser(auth: user))
        }
        
        func linkEmail() async throws {
            try await AuthManager.shared.linkEmail(email: email, password: password)
        }
    }
}
