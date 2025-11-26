//
//  RoutineListView.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/10/24.
//

import SwiftUI

struct RoutinesScreen: View {
    @Environment(RoutineService.self) var routineService
    @Environment(UserService.self) var userService
    @Environment(Router.self) var router

    var body: some View {
        VStack {
            switch (routineService.networkState, routineService.routines.isEmpty) {
            case (.loading, _):
                ProgressView()
                    .frame(maxHeight: .infinity, alignment: .center)

            case (.loaded, true):
                EmptyListView()

            case (.loaded, false):
                HighlightedSection()
                ListSection()

            case (.error,_):
                //TODO: Handle error state
                Text("Error loading routines")
                    .frame(maxHeight: .infinity, alignment: .center)
            }
        }
        .task {
            try? await routineService.loadRoutines(routineIds: userService.user.routines ?? [])
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationTitle(router.currentTab.rawValue.capitalized)
    }
}

#Preview {
    RoutinesScreen()
        .environment(Router())
        .preferredColorScheme(.dark)
}
