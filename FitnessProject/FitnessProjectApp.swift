//
//  FitnessProjectApp.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/6/24.
//

import SwiftUI
import Firebase
import FirebaseFirestore

@main
@MainActor
struct FitnessProjectApp: App {
    @State var appState = AppState()
    init() {
        FirebaseApp.configure()
//        appState.loadDb()
    }
    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(appState)
                .preferredColorScheme(.dark)
        }
    }
}
