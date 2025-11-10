//
//  RoutineListView.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/10/24.
//

import SwiftUI

struct RoutinesScreen: View {
    @Environment(RoutineService.self) var routineService
    @State private var viewModel = ViewModel()
    var body: some View {
        VStack {
            if routineService.routines.isEmpty {
                EmptyListView()
            } else {
                HighlightedSection()
                ListSection()
            }
        }
        .overlay(alignment: .bottom) {
            AddRoutineButton(viewModel: $viewModel)
        }
        .task {
            try? await routineService.loadRoutines(routineIds: ["C895BA1B-786F-49FD-BB7D-7D0FDB11D593"])
        }
        .navigationTitle("Routines")
    }
}

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
            .navigationTitle("Routines")
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
        }

    }

    struct AddRoutineButton: View {
        @Environment(Router.self) var router
        @Environment(RoutineService.self) var routineService
        @Binding var viewModel: ViewModel

        var body : some View {
            HStack {
                Spacer()

                Button {
                    router.push(destination: .createRoutineScreen(routine: nil, screenMode: .creation))
                } label: {
                    Image(systemName: "plus.circle")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .padding()
                }
                .disabled(viewModel.hasHitLimit)
                .buttonStyle(.plain)
                .onTapGesture {
                    if viewModel.hasHitLimit {
                        viewModel.showRoutineLimitAlert = true
                    }
                }
                .onChange(of: routineService.routines) { _, _ in
                    viewModel.hasHitLimit = routineService.routines.count == 5
                }
                .alert("You can only make 5 routines", isPresented: $viewModel.showRoutineLimitAlert) {
                    Button("Ok") {}
                }
            }
        }
    }
}
#Preview {
    RoutinesScreen()
        .environment(Router())
        .preferredColorScheme(.dark)
}
