//
//  SignUpView.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/19/24.
//

import SwiftUI

struct SignUpView: View {
    @Environment(Router.self) var router
    @State private var viewModel = ViewModel()
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack(alignment: .leading){
            Group{
                EntryFieldView(textBinding: $viewModel.name, placeholderString: "Name", iconImagename: "person.fill")
                EntryFieldView(textBinding: $viewModel.email, placeholderString: "Email", iconImagename: "envelope.fill")
                EntryFieldView(textBinding: $viewModel.password, placeholderString: "Password", isSecureField: true, iconImagename: "lock.fill")
                    .onChange(of: viewModel.password){ _,_ in
                        viewModel.verifyPasswordMatch()
                    }
                EntryFieldView(textBinding: $viewModel.passwordConfirmation, placeholderString: "Confirm Password", isSecureField: true, iconImagename: "exclamationmark.lock.fill")
                    .onChange(of: viewModel.passwordConfirmation){ _,_ in
                        viewModel.verifyPasswordMatch()
                    }
            }
            .padding(.horizontal, 15)
            .padding(.bottom, 5)
            ErrorFooterView(invalidField: !viewModel.passwordsMatch, errorMessage: "Passwords must match")
                .padding(.leading, 16)
        }
        Button {
            Task {
                if AuthManager.shared.isAnonymous{
                    await viewModel.linkEmail()
                    router.push(destination: .mainNavigationScreen)
                } else {
                    await viewModel.signUp()
                    router.push(destination: .mainNavigationScreen)
                }
            }
        } label: {
            Text("Sign Up")
                .padding(.vertical, 8)
                .padding(.horizontal, 50)
                .overlay (
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.secondary)
                )
        }
        .padding(.top, 15)
        .buttonStyle(.plain)
        .navigationTitle("Sign Up")
        .disabled(!viewModel.validSubmission)
        Spacer()
    }
}

#Preview {
    SignUpView()
        .preferredColorScheme(.dark)
}
