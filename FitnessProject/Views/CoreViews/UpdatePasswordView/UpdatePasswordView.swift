//
//  UpdatePasswordView.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 10/29/24.
//

import SwiftUI

struct UpdatePasswordView: View {
    @Environment(AuthService.self) var authService
    @State var viewModel =  ViewModel()
    var body: some View {
        VStack{
            VStack(alignment: .leading){
                EntryFieldView(
                    textBinding: $viewModel.newPassword,
                    placeholderString: "New Password",
                    keyboardType: .secure,
                    iconImagename: "lock.fill"
                )
                    .onChange(of: viewModel.newPassword){ _,_ in
                        viewModel.verifyPasswordMatch()
                    }
                
                EntryFieldView(
                    textBinding: $viewModel.confirmPassword,
                    placeholderString: "Confirm Password",
                    keyboardType: .secure,
                    iconImagename: "exclamationmark.lock.fill"
                )
                    .onChange(of: viewModel.confirmPassword){ _,_ in
                        viewModel.verifyPasswordMatch()
                    }
                ErrorFooterView(invalidField: !viewModel.passwordsMatch, errorMessage: "Passwords Must Match")
                    .padding(.leading, 5)
                ErrorFooterView(invalidField: viewModel.changeSucessful, errorMessage: "Password Changed Successfully!", successType: true)
                    .padding(.leading, 5)
            }
            .padding(.horizontal)
            .padding(.top, 45)
            .navigationTitle("Update Password")
            Button {
                Task {
                    await changePassword()
                }
            } label: {
                Text("Update Password")
                    .padding(.vertical, 8)
                    .padding(.horizontal, 50)
                    .overlay (
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.secondary)
                    )
            }
            .padding(.top, 15)
            .buttonStyle(.plain)
            Spacer()
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButton()
            }
        }
    }

    func changePassword() async {
        do {
            try await authService.updatePassword(viewModel.newPassword)
            viewModel.changeSucessful = true
            viewModel.newPassword = ""
            viewModel.confirmPassword = ""
        } catch {
            Log.error("Update password failed: \(error)")
        }
    }
}

#Preview {
    UpdatePasswordView()
        .preferredColorScheme(.dark)
        .environment(Router())
}
