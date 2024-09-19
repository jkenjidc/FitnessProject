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
        NavigationStack{
            if appState.authState == .loggedIn {
                MainNavigationView()
                    .preferredColorScheme(.dark)
                    .environment(appState)
            } else {
                WelcomeView()
                    .preferredColorScheme(.dark)
                    .environment(appState)
            }
        }
    }
}

#Preview {
    RootView()
}
