//
//  FitnessProjectApp.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/6/24.
//

import SwiftUI
import Firebase

@main
@MainActor
struct FitnessProjectApp: App {
    @State var appState = AppState()
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
//            NavigationStack(path: $appState.router.navPath){
                if appState.isLoggedIn {
                    MainNavigationView()
                        .preferredColorScheme(.dark)
                        .environment(appState)
                } else {
                    WelcomeView()
                        .preferredColorScheme(.dark)
                        .environment(appState)
//                }
            }
        }
    }
}
