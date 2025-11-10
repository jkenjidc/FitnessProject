//
//  TimerScreen.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 5/9/25.
//

import SwiftUI

struct TimerScreen: View {
    @Environment(RoutineService.self) var routineService
    @State private var updateModel: RoutineToUpdate

    init(routine: Routine) {
        _updateModel = State(initialValue: RoutineToUpdate(routine: routine))
    }

    var body: some View {
        VStack {
            TimerHeader(routineName: updateModel.routine.name)
            TimerExerciseList(exercises: $updateModel.routine.exercises)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            Toolbar(routine: updateModel.routine)
        }
        .onAppear {
            print("*****TIMER SCREEN DATA \(updateModel.routine.exercises)")
        }
    }
}

extension TimerScreen {
    struct Toolbar: ToolbarContent {
        @Environment(RoutineService.self) var routineService
        @Environment(Router.self) var router
        @State var finishConfirmationPresented: Bool = false
        var routine: Routine
        var body: some ToolbarContent {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    router.pop()
                } label: {
                    Text("Cancel")
                        .foregroundStyle(.red)
                }
            }

            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    finishConfirmationPresented = true
                } label: {
                    Text("finish")
                        .tint(.green)
                }
                .alert("Save Routine Edits?",isPresented: $finishConfirmationPresented) {
                    Button("Save") {
                        Task {
                            try? await routineService.updateRoutine(routine: routine)
                        }
                        router.pop()
                    }
                }
            }
        }

    }

    @Observable
    class RoutineToUpdate {
        var routine: Routine

        init(routine: Routine) {
            self.routine = routine
        }
    }
}

#Preview {
    TimerScreen(routine: .example[0])
        .preferredColorScheme(.dark)
        .environment(Router())
}
