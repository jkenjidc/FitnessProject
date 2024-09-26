//
//  RootView.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/19/24.
//

import SwiftUI

struct RootView: View {
    @Environment(AppState.self) var appState
    var body: some View {
        ZStack{
            NavigationStack{
                MainNavigationView()
            }
        }
        .onAppear {
            Task{
                do{
                    try AuthManager.shared.checkAuth()
                } catch {
                    print(error)
                }
            }
        }
        .fullScreenCover(isPresented: AuthManager.shared.signOutBinding, content: {
            WelcomeView()
        })
            
    }
}

#Preview {
    RootView()
}
