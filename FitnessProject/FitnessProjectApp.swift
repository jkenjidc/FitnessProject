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
    @State var hkManager = HealthKitManager()
    init() {
        FirebaseApp.configure()
        configureCache()
    }
    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(router)
                .environment(hkManager)
                .preferredColorScheme(.dark)
        }
    }

    func configureCache() {
        let memoryCapacity = 4 * 1024 * 1024
        let diskCapacity = 100 * 1024 * 1024
        let urlCache = URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: "exercisesListCache")
        URLCache.shared = urlCache
    }
}
