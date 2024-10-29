//
//  ProfileView.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/10/24.
//

import SwiftUI

struct ProfileView: View {
    @Environment(Router.self) var router
    @State  var viewModel = ViewModel()
    @Bindable var dataManager = DataManager.shared
    var body: some View {
        VStack(alignment: .center){
            Image(systemName: "person.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width:180, height: 180)
                .padding(.top, 15)
            if dataManager.user.isAnonymous {
                Text("Guest user")
            }
            Text("User ID \(dataManager.user.id)")
                .padding(.bottom, 25)
            if dataManager.user.isAnonymous {
                Button {
                    router.push(destination: .signUpScreen)
                } label: {
                    Text("Create account")
                }
                //Need to delete this since user must not be able to log out when anonymous
                Button {
                    viewModel.signOut {
                        router.popToRoot()
                    }
                } label: {
                    Text("log out")
                        .foregroundStyle(.red)
                }
                
            } else {
                HStack{
                    Button {
                        viewModel.signOut {
                            router.popToRoot()
                        }
                    } label: {
                        Text("log out")
                            .foregroundStyle(.red)
                    }
                    .buttonStyle(.plain)
                    Spacer()
                    Button {
                        router.push(destination: .updatePasswordScreen)
                    } label: {
                        Text("Update password")
                    }
                }
                .padding(.horizontal, 45)
            }
            Spacer()
            Button(role: .destructive) {
                viewModel.confirmAccountDeletion.toggle()
            } label: {
                Text("Delete Account")
            }
            .padding(.bottom, 25)
        }
        .alert("Delete account", isPresented: $viewModel.confirmAccountDeletion){
            Button("OK", role: (.destructive)){
                Task {
                    await viewModel.deleteAccount {
                        router.popToRoot()
                    }
                }
            }
        } message: {
            Text("Are you sure you want to delete your account? This action can't be reversed")
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ProfileView()
        .environment(Router())
        .preferredColorScheme(.dark)
}
