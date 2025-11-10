//
//  RoutinesScreen+Components.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 11/9/25.
//

import SwiftUI

extension RoutinesScreen {
    struct EmptyListView: View {
        var body: some View {
            ContentUnavailableView{
                Image(systemName: "figure.flexibility")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundStyle(.secondary)
            } description: {
                Text("No routines added")
            }
            .overlay(alignment: .bottom) {
                AddRoutineButton()
            }
        }
    }

    struct HighlightedSection: View {
        @Environment(RoutineService.self) var routineService

        var body: some View {
            if !routineService.routinesOfTheDay.isEmpty {
                VStack(alignment: .leading){
                    Text("ROUTINE FOR TODAY")
                        .foregroundStyle(.secondary)
                        .bold()
                        .font(.headline)
                        .padding(.leading, 32)
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(alignment: .center){
                            ForEach(routineService.routinesOfTheDay) { routine in
                                StartRoutineCircleGraphic(routineId: routine.id)
                                    .onAppear {
                                        print(routine.exercises)
                                    }
                            }
                        }
                        .scrollTargetLayout()
                    }
                    .transition(.scale)
                    .scrollTargetBehavior(.paging)
                    .scrollBounceBehavior(.basedOnSize)
                }
            }

        }
    }

    struct ListSection: View {
        @Environment(Router.self) var router
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
                                try? await routineService.deleteRoutine(at: indexSet)
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

    struct AddRoutineButton: View {
        @Environment(Router.self) var router
        @Environment(RoutineService.self) var routineService
        @State private var showRoutineLimitAlert = false

        //TODO: Refactor to add limit somewhere centralized
        var hasHitLimit: Bool {
            routineService.routines.count == 5
        }

        var body : some View {
            HStack {
                Spacer()

                Button {
                    if hasHitLimit {
                        showRoutineLimitAlert = true
                    } else {
                        router.push(destination: .createRoutineScreen(routine: nil, screenMode: .creation))
                    }
                } label: {
                    Image(systemName: "plus.circle")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .padding()
                }
                .disabled(hasHitLimit)
                .buttonStyle(.plain)
                .alert("You can only make 5 routines", isPresented: $showRoutineLimitAlert) {
                    Button("Ok") {}
                }
            }
        }
    }
}
