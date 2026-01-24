//
//  ListSection.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 11/27/25.
//

import SwiftUI

extension RoutinesScreen {
    struct ListSection: View {
        @Environment(Router.self) var router
        @Environment(AppCoordinator.self) var appCoordinator
        @Environment(RoutineService.self) var routineService
        var body: some View {
            VStack(alignment: .leading, spacing: 0){
                List{
                    Section {
                        ForEach(routineService.routines){ routine in
                            Button{
                                router.presentModal(.routineInfo(routine: routine))
                            } label: {
                                RoutineListCellView(title: routine.name)
                            }
                            .buttonStyle(.plain)
                        }
                        .onDelete(perform: { indexSet in
                            Task{
                                try? await appCoordinator.deleteRoutine(indexSet)
                            }
                        })
                    } header: {
                        Text("All Routines")
                            .bold()
                            .font(.headline)
                    }
                }
            }
            .overlay(alignment: .bottom) {
                AddRoutineButton()
            }
        }
    }
}

#Preview {
    RoutinesScreen.ListSection()
}
