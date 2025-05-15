//
//  TimerScreen.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 5/9/25.
//

import SwiftUI

struct TimerScreen: View {
    @State var routine: Routine = .example[0]
    var body: some View {
        VStack {
            TimerHeader(routineName: routine.name)
            TimerExerciseList(exercises: $routine.exercises)
        }
    }
}

#Preview {
    TimerScreen()
        .preferredColorScheme(.dark)
}
