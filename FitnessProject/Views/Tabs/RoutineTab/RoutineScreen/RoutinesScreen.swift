//
//  RoutineListView.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/10/24.
//

import SwiftUI

struct RoutinesScreen: View {
    @Environment(RoutineService.self) var routineService
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
            try? await routineService.loadRoutines(routineIds: ["C895BA1B-786F-49FD-BB7D-7D0FDB11D593"])
        }
        .navigationTitle("Routines")
    }
}

#Preview {
    RoutinesScreen()
        .environment(Router())
        .preferredColorScheme(.dark)
}
