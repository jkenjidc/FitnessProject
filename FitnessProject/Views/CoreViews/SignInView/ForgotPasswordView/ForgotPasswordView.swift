//
//  ForgotPasswordView.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 11/21/24.
//

import SwiftUI

struct ForgotPasswordView: View {
    @Environment(Router.self) var router
    @Environment(AuthService.self) var authService
    @State private var email = ""
    @State private var showConfirmation = false
    var body: some View {
        VStack{
            Text("Forgot Password?")
                .font(.system(size: 35).bold())
            EntryFieldView(textBinding: $email, placeholderString: "Email", iconImagename: "envelope.fill")
                .padding(.horizontal, 15)
            Button {
                Task{
                    await resetPassword()
                }
            } label: {
                Text("Send Password Reset Link")
                    .padding(.vertical, 8)
                    .padding(.horizontal, 50)
                    .overlay (
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.secondary)
                    )
            }
            .disabled(email.isEmpty)
            .buttonStyle(.plain)
        }
        .alert("Reset Link Sent", isPresented: $showConfirmation){
            Button("ok"){router.dismissSheet()}
        } message: {
            Text("If an account with this email exists, you will receive a link to reset your password")
        }
    }
    func resetPassword() async {
        do {
            try await authService.resetPassword(email: email)
        } catch {
            Log.error("Reset password failed: \(error)")
        }
        showConfirmation.toggle()
    }
}

#Preview {
    ForgotPasswordView()
}
