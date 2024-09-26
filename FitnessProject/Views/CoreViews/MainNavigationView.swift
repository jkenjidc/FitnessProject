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
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    MainNavigationView()
        .environment(AppState())
        .preferredColorScheme(.dark)
}
