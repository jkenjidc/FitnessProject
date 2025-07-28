//
//  ExercisesListView.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 4/9/25.
//

import SwiftUI
import Foundation

struct ExercisesListView: View {
    let filteredExercises: [ExerciseV2]

    init(for exercises: [ExerciseV2]) {
        self.filteredExercises = exercises
    }

    var body: some View {
        List {
            ForEach(filteredExercises) { exercise in
                HStack(spacing: 30) {
                    AsyncImage(url: exercise.gifUrl) { image in
                        image
                            .resizable()
                    } placeholder: {
                        Color.gray
                    }
                    .frame(width: 50, height: 50)
                    Text(exercise.name)
                }
                .transition(.slide)
                .listRowInsets(EdgeInsets(top: 15, leading: 0, bottom: 15, trailing: 0))
            }
        }
        .listStyle(.plain)

    }
}

#Preview {
    ExercisesListView(for: ExerciseV2.mockList)
        .preferredColorScheme(.dark)
}
