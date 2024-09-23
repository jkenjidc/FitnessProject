//
//  ProfileView.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/10/24.
//

import SwiftUI

struct ProfileView: View {
    @Environment(AppState.self) var appState
    @State private var authUser: AuthDataResultModel? = nil
    var body: some View {
        NavigationStack{
            VStack{
                if appState.isAnonymous{
                    NavigationLink {
                        SignUpView()
                    } label: {
                        Text("Create account")
                    }
                    
                } else {
                    Button {
                        Task {
                            do {
                                
                                try appState.shared.signOut()
                                appState.showsignInView = true
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
                                try await appState.updatePassword(password: "test1243")
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
        
        
    }
}

#Preview {
    ProfileView()
        .environment(AppState())
}
