//
//  SignUpView.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/19/24.
//

import SwiftUI

struct SignUpScreen: View {
    @Environment(Router.self) var router
    @Environment(AppCoordinator.self) var appCoordinator
    @State private var viewModel = ViewModel()
    @State var callState: InteractiveCallState = .idle
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack {
            entryFields

            ErrorFooterView(invalidField: !viewModel.passwordsMatch, errorMessage: "Passwords must match")
                .padding(.leading, 16)

            // TODO: Handle anonymous linking
            Button("Sign Up") {
                Task {
                    await handleSignUp()
                }
            }
            .buttonStyle(.fitness(.secondary))
            .disabled(!viewModel.validSubmission)
        }
        .loadingOverlay($callState)
        .navigationTitle("Sign Up")
        .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert){
            Button("ok"){}
        } message: {
            Text(viewModel.alertMessage)
        }
        Spacer()
    }

    // TODO: Refactor to avoid duplicating logic
    @MainActor func handleSignUp() async {
        callState = .loading
        do {
            try await appCoordinator.signUp(viewModel.email, viewModel.password, viewModel.name)
        } catch {
            callState = .error
        }
    }
}

extension SignUpScreen {
    var entryFields: some View {
        Group{
            EntryFieldView(
                textBinding: $viewModel.name,
                placeholderString: "Name",
                iconImagename: "person.fill"
            )

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
            .onChange(of: viewModel.password){ _,_ in
                viewModel.verifyPasswordMatch()
            }

            EntryFieldView(
                textBinding: $viewModel.passwordConfirmation,
                placeholderString: "Confirm Password",
                keyboardType: .secure,
                iconImagename: "exclamationmark.lock.fill"
            )
            .onChange(of: viewModel.passwordConfirmation){ _,_ in
                viewModel.verifyPasswordMatch()
            }
        }
        .padding(.horizontal, 15)
        .padding(.bottom, 5)
    }
}

#Preview {
    SignUpScreen()
        .environment(Router())
        .preferredColorScheme(.dark)
}
