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
    @Environment(AppCoordinator.self) var appCoordinator
    @State var callState: InteractiveCallState = .idle

    var body: some View {
        VStack(spacing: 20) {
            entryFields

            buttons
        }
        .loadingOverlay($callState)
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

    var entryFields: some View {
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
    }

    var buttons: some View {
        VStack {
            Button("Sign In") {
                Task{
                    await handleSignIn()
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

    @MainActor func handleSignIn() async {
        callState = .loading
        do {
            try await appCoordinator.signIn(viewModel.email, viewModel.password)
        } catch {
            callState = .error
        }
    }
}

#Preview {
    SignInScreen()
        .preferredColorScheme(.dark)
        .environment(Router())
}
