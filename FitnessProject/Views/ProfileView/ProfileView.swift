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
                let user = DataManager.shared.user
                Text("User ID \(user.id)")
                    
                
                
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
                    Text("Name: \(user.name)")
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
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    
}

#Preview {
    ProfileView()
        .environment(AppState())
        .preferredColorScheme(.dark)
}
