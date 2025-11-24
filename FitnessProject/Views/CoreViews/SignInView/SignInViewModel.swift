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
        
        func signIn() async {
            do {
                Log.info("Attempting sign in")
                try await AuthManager.shared.signInUser(email: email, password: password)
                
                Log.info("Attempting loading user")
                try await DataManager.shared.loadUser()
                
                Log.info("Attempting loading routines")
                try await DataManager.shared.loadRoutines()
                
            } catch {
                let errorMessage = (error as? AuthError)?.errorDescription ?? AuthError.defaultMessage
                Log.error(errorMessage)
                alertTitle = "Log In Failed"
                alertMessage = errorMessage
                showAlert = true
                
            }
        }
        
        func resetPassword() async {
            do {
                try await AuthManager.shared.resetPassword(email: email)
            } catch {
                print(error)
            }
        }
    }
}
