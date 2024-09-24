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
            AuthManager.shared.checkAuth()
        }
        .fullScreenCover(isPresented: AuthManager.shared.signOutBinding, content: {
            WelcomeView()
        })
            
    }
}

#Preview {
    RootView()
}
