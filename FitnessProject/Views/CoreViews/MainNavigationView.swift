//
//  MainNavigationView.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/10/24.
//

import SwiftUI

struct MainNavigationView: View {
    @Environment(Router.self) var router
    @State private var selectedTab = 1
    private var tabBarFontSize = CGFloat(25)
    var navTitle: String {
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
                    Label("Profile", systemImage: "person")
                }
                .tag(0)
            
            RoutineListView()
                .tabItem {
                    Label("Routines", systemImage: "dumbbell.fill")
                }
                .tag(1)
            
            PersonalProgressView()
                .tabItem {
                    Label("Progress", systemImage: "chart.line.uptrend.xyaxis")
                }
                .tag(2)

            ExercisesListView()
                .tabItem {
                    Label("Exercises", systemImage: "figure.run")
                }
                .tag(3)
        }
        .navigationTitle(navTitle)
        .toolbar {
            if selectedTab == 0 {
                ToolbarItem(placement: .topBarTrailing){
                    Button {
                        router.push(destination: .settingsScreen)
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 20))
                    }
                    .padding()
                    .buttonStyle(.plain)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
    }
}

//#Preview {
//    MainNavigationView()
//        .preferredColorScheme(.dark)
//}
