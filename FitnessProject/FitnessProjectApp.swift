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
    @State var router = Router()
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(router)
                .preferredColorScheme(.dark)
        }
    }
}
