//
//  TimerScreen.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 5/9/25.
//

import SwiftUI

struct TimerScreen: View {
    @Environment(Router.self) var router
    let routine: Routine
    var body: some View {
        VStack {
            TimerHeader(routineName: routine.name)
            TimerExerciseList(exercises: routine.exercises)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar{
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
                    router.pop()
                } label: {
                    Text("finish")
                        .tint(.green)
                }
            }
        }

    }
}

#Preview {
    TimerScreen(routine: .example[0])
        .preferredColorScheme(.dark)
        .environment(Router())
}
