//
//  SignUpView.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/19/24.
//

import SwiftUI

struct SignUpView: View {
    @Environment(AppState.self) var appState
    @State private var email = ""
    @State private var password = ""
    @Environment(\.dismiss) var dismiss
    var body: some View {
        TextField("Email", text: $email)
        SecureField("Password", text: $password)
        Button {
            Task {
                if appState.isAnonymous{
                    try await appState.linkEmail(email: email, password: password)
                    dismiss()
                } else {
                    try await appState.signUp(email: email, password: password)
                }
            }
        } label: {
            Text("Sign Up")
        }
    }
    
}

#Preview {
    SignUpView()
}
