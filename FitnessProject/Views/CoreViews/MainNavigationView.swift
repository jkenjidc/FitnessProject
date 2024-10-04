//
//  MainNavigationView.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/10/24.
//

import SwiftUI

struct MainNavigationView: View {
    @Environment(AppState.self) var appState
    @State private var selectedTab = 1
    private var tabBarFontSize = CGFloat(25)
    @MainActor var navTitle: String {
        switch(selectedTab) {
        case 0: "Welcome \(DataManager.shared.user.name.isEmpty ? "Guest" : DataManager.shared.user.name)"
        case 1: "Routines"
        default:"Progress"
        }
    }
    var body: some View {
            TabView(selection: $selectedTab) {
                ProfileView()
                    .tabItem {
                        Image(systemName: "person")
                    }
                    .tag(0)
                
                RoutineListView()
                    .tabItem {
                        Image(systemName: "dumbbell.fill")
                    }
                    .tag(1)
                
                PersonalProgressView()
                    .tabItem {
                        Image(systemName: "chart.line.uptrend.xyaxis")
                    }
                    .tag(2)
                
                
            }
        .navigationTitle(navTitle)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    MainNavigationView()
        .environment(AppState())
        .preferredColorScheme(.dark)
}
