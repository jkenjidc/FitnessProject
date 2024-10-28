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
    var body: some View {
        VStack(alignment: .center){
            HStack{
                Spacer()
                Button {
                    router.push(destination: .settingsScreen)
                } label: {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 25))
                }
                .padding()
                .buttonStyle(.plain)
            }
            Image(systemName: "person.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width:180, height: 180)
            let user = DataManager.shared.user
            if user.isAnonymous {
                Text("Guest user")
            }
            Text("User ID \(user.id)")
                .padding(.bottom, 25)
            if AuthManager.shared.isAnonymous{
                Button {
                    router.push(destination: .signUpScreen)
                } label: {
                    Text("Create account")
                }
                
                Button {
                    Task {
                        do {
                            try AuthManager.shared.signOut()
                            router.popToRoot()
                        } catch {
                            print(error)
                        }
                    }
                    
                } label: {
                    Text("log out")
                }
                
            } else {
                HStack{
                    Button {
                        Task {
                            do {
                                try AuthManager.shared.signOut()
                                router.popToRoot()
                            } catch {
                                print(error)
                            }
                        }
                    } label: {
                        Text("log out")
                            .foregroundStyle(.red)
                    }
                    .buttonStyle(.plain)
                    Spacer()
                    Button {
                        
                        Task {
                            do {
                                try await AuthManager.shared.updatePassword(password: "test1243")
                            } catch {
                                print(error)
                            }
                        }
                    } label: {
                        Text("Update password")
                    }
                }
                .padding(.horizontal, 45)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ProfileView()
        .environment(Router())
        .preferredColorScheme(.dark)
}
