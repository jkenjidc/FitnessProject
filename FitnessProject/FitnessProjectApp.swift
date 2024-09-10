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
            WelcomeView()
                .preferredColorScheme(.dark)
                .environmentObject(dataManager)
        }
    }
}
