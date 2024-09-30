//
//  ProfileView.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/10/24.
//

import SwiftUI

struct ProfileView: View {
    @Environment(AppState.self) var appState
    @State  var viewModel = ViewModel()
    var body: some View {
        NavigationStack{
            VStack(alignment: .center){
                
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width:180, height: 180)
                Text("Guest user")
//                if let user = AuthManager.shared.authProfile {
//                    Text("User ID \(user.uid)")
//                    
//                }
                
                if let user = viewModel.user {
                    Text("User ID \(user.userId)")
                    
                }
                
                if AuthManager.shared.isAnonymous{
                    NavigationLink {
                        SignUpView()
                    } label: {
                        Text("Create account")
                    }
                    
                    Button {
                        Task {
                            do {
                                
                                try AuthManager.shared.signOut()
                            } catch {
                                print(error)
                            }
                        }
                    } label: {
                        Text("log out")
                    }
                    
                } else {
                    Text("Name: \(appState.user.name)")
                    Button {
                        Task {
                            do {
                                
                                try AuthManager.shared.signOut()
                            } catch {
                                print(error)
                            }
                        }
                    } label: {
                        Text("log out")
                    }
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
                Button {
                    viewModel.togglePremiumStatus()
                }label: {
                    Text("User is premium: \((viewModel.user?.isPremium ?? false).description.capitalized)")
                }
            }
        }
        .frame(maxWidth: .infinity)
        .onAppear {
            Task {
                try? await viewModel.loadCurrentUser()
            }
        }
        
        
    }
    
    
}

#Preview {
    ProfileView()
        .environment(AppState())
        .preferredColorScheme(.dark)
}
