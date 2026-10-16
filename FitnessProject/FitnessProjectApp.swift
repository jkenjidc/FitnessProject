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
struct FitnessProjectApp: App {
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            RootViewV2()
                .injectServices()
                .preferredColorScheme(.dark)
        }
    }
}
