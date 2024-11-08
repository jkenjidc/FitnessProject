//
//  SignInView.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/20/24.
//

import SwiftUI

struct SignInView: View {
    @State var viewModel =  ViewModel()
    @Environment(Router.self) var router
    @Environment(\.dismiss) var dismiss
    var body: some View {
            VStack(){
                Group{
                    VStack(alignment: .leading){
                        EntryFieldView(textBinding: $viewModel.email, placeholderString: "Email", iconImagename: "envelope.fill")
                        EntryFieldView(textBinding: $viewModel.password, placeholderString: "Password", isSecureField: true, iconImagename: "lock.fill")
                    }
                    Button {
                        Task{
                            await viewModel.signIn {
                                router.push(destination: .mainNavigationScreen)
                            }
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
                            await viewModel.resetPassword()
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
            .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert){
                Button("ok"){}
            } message: {
                Text(viewModel.alertMessage)
            }
        }
    }

#Preview {
    SignInView()
        .preferredColorScheme(.dark)
}
