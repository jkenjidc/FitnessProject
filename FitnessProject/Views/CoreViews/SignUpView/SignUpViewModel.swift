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
        
        func signUp(goToHomeScreen:() -> Void) async {
            do {
                Log.info("Attempting create auth profile")
                let user = try await AuthManager.shared.createUser(email: email, password: password)
                
                Log.info("Attempting to create user")
                try await DataManager.shared.createUser(user: CurrentUser(auth: user, name: name))
                
                goToHomeScreen()
            } catch {
                let errorMessage = (error as? AuthError)?.errorDescription ?? AuthError.defaultMessage
                Log.error(errorMessage)
                alertTitle = "Log In Failed"
                alertMessage = errorMessage
                showAlert = true
            }
        }
        
        func linkEmail(goToHomeScreen:() -> Void) async {
            do {
                try await AuthManager.shared.linkEmail(email: email, password: password)
                try await DataManager.shared.updateCurrentUser(isLinking: true, newName: self.name)
                
                goToHomeScreen()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
