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
    @StateObject var dataManager = DataManager()
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            if dataManager.isLoggedIn {
                MainNavigationView()
                    .preferredColorScheme(.dark)
                    .environmentObject(dataManager)
            } else {
                WelcomeView()
                    .preferredColorScheme(.dark)
                    .environmentObject(dataManager)
            }
        }
    }
}
