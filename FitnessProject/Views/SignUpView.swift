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
        TextField("Password", text: $password)
        Button {
            withAnimation {
                appState.shared.signIn(email: email, password: password)
//                dismiss()
            }
        } label: {
            Text("Sign Up")
        }
    }
}

#Preview {
    SignUpView()
}
