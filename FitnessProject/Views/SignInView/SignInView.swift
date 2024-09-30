//
//  SignInView.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/20/24.
//

import SwiftUI

struct SignInView: View {
    @Environment(AppState.self) var appState
    @State var viewModel =  ViewModel()
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack{
            VStack(){
                Group{
                    VStack(alignment: .leading){
                        EntryFieldView(textBinding: $viewModel.email, placeholderString: "Email", iconImagename: "envelope.fill")
//                        ErrorFooterView(invalidField: viewModel.invalidInputs)
//                            .padding(.leading, 5)
                        
                        EntryFieldView(textBinding: $viewModel.password, placeholderString: "Password", isSecureField: true, iconImagename: "lock.fill")
//                        ErrorFooterView(invalidField: viewModel.invalidInputs)
//                            .padding(.leading, 5)
                    }
                    Button {
                        Task{
                            try await viewModel.signIn()
                        }
                    } label: {
                        Text("Sign In")
                            .padding(.vertical, 8)
                            .padding(.horizontal, 50)
                            .overlay (
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(.secondary)
                            )
                    }
                    .disabled(viewModel.invalidInputs)
                    .buttonStyle(.plain)
                    
                    Button {
                        Task{
                            try await AuthManager.shared.resetPassword(email: viewModel.email)
                        }
                    } label: {
                        Text("Forgot Password?")
                            .padding(.vertical, 8)
                            .padding(.horizontal, 50)
                            .overlay (
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(.secondary)
                            )
                    }
                    .disabled(viewModel.invalidInputs)
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 15)
                .padding(.bottom, 5)
                Spacer()
            }
            .navigationTitle("Sign In")
        }
    }
}

#Preview {
    SignInView()
        .environment(AppState())
        .preferredColorScheme(.dark)
}
