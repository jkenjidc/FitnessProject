//
//  ProfileView.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/10/24.
//

import SwiftUI

struct ProfileView: View {
    @Environment(AppState.self) var appState
    var body: some View {
        NavigationStack{
            VStack(alignment: .center){
                    
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width:180, height: 180)
                if AuthManager.shared.isAnonymous{
                    Text("Guest user")
                    if let user = appState.authProfile {
                        Text("User ID \(user.uid)")
                    }
                    NavigationLink {
                        SignUpView()
                    } label: {
                        Text("Create account")
                    }
                    
                    Button {
                        Task {
                            do {
                                
                                try AuthManager.shared.signOut()
//                                appState.showsignInView = true
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
            }
            .onAppear {
                try? AuthManager.shared.loadAuthProfile()
            }
            .frame(maxWidth: .infinity)
            
            
        }
        
        
    }
}

#Preview {
    ProfileView()
        .environment(AppState())
        .preferredColorScheme(.dark)
}
