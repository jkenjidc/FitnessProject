//
//  FitnessProjectApp.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/6/24.
//

import SwiftUI
import Firebase

@main
struct FitnessProjectApp: App {
    @StateObject var appState = AppState()
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            if appState.isLoggedIn {
                MainNavigationView()
                    .preferredColorScheme(.dark)
                    .environmentObject(appState)
            } else {
                WelcomeView()
                    .preferredColorScheme(.dark)
                    .environmentObject(appState)
            }
        }
    }
}
