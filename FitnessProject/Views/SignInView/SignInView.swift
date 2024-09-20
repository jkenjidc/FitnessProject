//
//  SignInView.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/20/24.
//

import SwiftUI

struct SignInView: View {
    @Environment(AppState.self) var appState
    @State private var email = ""
    @State private var password = ""
    @State private var showForgotPasswordField = false
    @Environment(\.dismiss) var dismiss
    var body: some View {
        TextField("Email", text: $email)
        SecureField("Password", text: $password)
        Button {
            Task{
                try await appState.signIn(email: email, password: password)
            }
        } label: {
            Text("Sign In")
        }
        
        Button {
            Task{
                try await appState.resetPassword(email: email)
            }
        } label: {
            Text("Forgot password?")
        }
    }
}

#Preview {
    SignInView()
}
