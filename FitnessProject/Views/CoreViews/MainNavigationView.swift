//
//  MainNavigationView.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/10/24.
//

import SwiftUI

struct MainNavigationView: View {
    @Environment(Router.self) var router

    var body: some View {
        @Bindable var router = router

        TabView(selection: $router.currentTab) {
            // MARK: Exercises Tab
            NavigationStack(path: $router.exercisesPath) {
                ExercisesScreen()
                    .navigationDestination(for: Destination.self) { destination in
                        router.build(destination: destination)
                    }
            }
            .tabItem {
                Label(Tabs.exercises.rawValue.capitalized, systemImage: Tabs.exercises.systemImageName)
            }
            .tag(Tabs.exercises)

            // MARK: Routines Tab
            NavigationStack(path: $router.routinesPath) {
                RoutinesScreen()
                    .navigationDestination(for: Destination.self) { destination in
                        router.build(destination: destination)
                    }
            }
            .tabItem {
                Label(Tabs.routines.rawValue.capitalized, systemImage: Tabs.routines.systemImageName)
            }
            .tag(Tabs.routines)

            // MARK: Progress Tab
            NavigationStack(path: $router.progressPath) {
                PersonalProgressScreen()
                    .navigationDestination(for: Destination.self) { destination in
                        router.build(destination: destination)
                    }
            }
            .tabItem {
                Label(Tabs.progress.rawValue.capitalized, systemImage: Tabs.progress.systemImageName)
            }
            .tag(Tabs.progress)
        }
        .sheet(item: $router.sheet){ sheet in
            router.buildSheet(sheet: sheet)
        }
        .fullScreenCover(item: $router.fullScreenCover){ cover in
            router.buildCover(cover: cover)
        }
        .modal(item: $router.modal) { modal in
            router.buildModal(modal: modal)
        }
    }
}

#Preview {
    MainNavigationView()
        .preferredColorScheme(.dark)
        .environment(Router())
}
