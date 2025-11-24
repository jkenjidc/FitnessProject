//
//  SignInView.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/20/24.
//

import SwiftUI

struct SignInScreen: View {
    @State var viewModel =  ViewModel()
    @Environment(Router.self) var router
    @Environment(\.dismiss) var dismiss
    @Environment(AuthService.self) var authService

    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 15){
                EntryFieldView(
                    textBinding: $viewModel.email,
                    placeholderString: "Email",
                    iconImagename: "envelope.fill"
                )

                EntryFieldView(
                    textBinding: $viewModel.password,
                    placeholderString: "Password",
                    keyboardType: .secure,
                    iconImagename: "lock.fill"
                )
            }

            VStack {
                Button("Sign In") {
                    Task{
                        await authService.signIn(email: viewModel.email, password: viewModel.password)
                    }
                }
                .buttonStyle(.fitness(.secondary))
                .disabled(viewModel.invalidInputs)
                .foregroundStyle(viewModel.invalidInputs ? .secondary : .primary)

                Button("Forgot Password?") {
                    router.presentSheet(.forgotPassswordSheet)
                }
                .buttonStyle(.fitness(.secondary))
            }

        }
        .padding(.horizontal, 15)
        .frame(maxHeight: .infinity, alignment: .top)
        .navigationTitle("Sign In")
        .navigationBarTitleDisplayMode(.inline)
        .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert){
            Button("ok"){}
        } message: {
            Text(viewModel.alertMessage)
        }
    }
}

#Preview {
    SignInScreen()
        .preferredColorScheme(.dark)
        .environment(Router())
}
