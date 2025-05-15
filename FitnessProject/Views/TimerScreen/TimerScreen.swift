//
//  TimerScreen.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 5/9/25.
//

import SwiftUI

struct TimerScreen: View {
    let routine: Routine
    var body: some View {
        VStack {
            TimerHeader(routineName: routine.name)
            TimerExerciseList(exercises: routine.exercises)
        }
    }
}

#Preview {
    TimerScreen(routine: .example[0])
        .preferredColorScheme(.dark)
}
