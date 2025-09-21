//
//  MainNavigationView.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/10/24.
//

import SwiftUI

struct MainNavigationView: View {
    @Environment(Router.self) var router
    @State private var selectedTab: Tabs = .routines
    var body: some View {
        TabView(selection: $selectedTab) {
            ExercisesScreen()
                .tabItem {
                    Label(Tabs.exercises.rawValue.capitalized, systemImage: Tabs.exercises.systemImageName)
                }
                .tag(Tabs.exercises)

            RoutineListView()
                .tabItem {
                    Label(Tabs.routines.rawValue.capitalized, systemImage: Tabs.routines.systemImageName)
                }
                .tag(Tabs.routines)

            PersonalProgressScreen()
                .tabItem {
                    Label(Tabs.progress.rawValue.capitalized, systemImage: Tabs.progress.systemImageName)
                }
                .tag(Tabs.progress)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationTitle(selectedTab.rawValue.capitalized)
        .toolbar {
            profileButtonToolbarItem
        }
    }

    @ToolbarContentBuilder
    var profileButtonToolbarItem: some ToolbarContent {
        if selectedTab == .progress {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    router.push(destination: .profileScreen)
                } label: {
                    Label("Profile", systemImage: "person")
                }
                .buttonStyle(.plain)
            }
        }
    }
}

fileprivate enum Tabs: String {
    case exercises = "exercises"
    case routines  = "routines"
    case progress = "progress"

    var systemImageName: String {
        switch self {
        case .exercises:
            return "figure.run"
        case .routines:
            return "dumbbell.fill"
        case .progress:
            return "chart.line.uptrend.xyaxis"
        }
    }
}

//#Preview {
//    MainNavigationView()
//        .preferredColorScheme(.dark)
//}
