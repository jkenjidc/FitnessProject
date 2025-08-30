//
//  TimerExerciseList.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 5/14/25.
//

import SwiftUI

extension TimerScreen {
    struct TimerExerciseList: View {
        let exercises: [Exercise]

        var body: some View {
            ScrollView {
                VStack(spacing: 10) {
                    listHeader
                    ForEach(exercises) { exercise in
                        ExerciseListRow(exercise)
                    }
                }
            }
            .padding(.horizontal, 30)
        }
        private var listHeader: some View {
            HStack {
                Text("Exercise")
                Spacer()
                Text("Last Attempt")
            }
            .foregroundStyle(.secondary)
        }
    }

    private struct ExerciseListRow: View {
        @State private var exercise: Exercise
        init(_ exercise: Exercise) {
            _exercise = State(initialValue: exercise)
        }
        var body: some View {

            DisclosureGroup {
                HStack {
                    VStack(alignment: .center, spacing: 12) {
                        Text("Weight")

                        ForEach($exercise.sets) { $exerciseSet in
                            TextField("\(exerciseSet.weight)", value: $exerciseSet.weight, format: .number)
                                .padding(.vertical, 4)
                                .padding(.horizontal, 6)
                                .multilineTextAlignment(.center)
                                .keyboardType(.decimalPad)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(.white, lineWidth: 2)
                                )
                        }
                    }

                    VStack(alignment: .center, spacing: 12) {
                        Text("Reps")
                        ForEach($exercise.sets) { $exerciseSet in
                            TextField("\(exerciseSet.reps)", value: $exerciseSet.reps, format: .number)
                                .padding(.vertical, 4)
                                .padding(.horizontal, 6)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.center)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(.white, lineWidth: 2)
                                )
                        }
                    }
                }
                .padding(.vertical, 16)
                .tint(.white)
            } label: {
                HStack {
                    Text(exercise.name)
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("2 Weeks ago")
                        Text("100lbs x 3")
                    }
                    .offset(x: 20)
                }
                .tint(.clear)
            }
            .padding(16)
            .background(.blue.opacity(0.7))
            .cornerRadius(10)
            .foregroundColor(.white)
            .tint(.clear)
        }
    }
}

#Preview {
    TimerScreen.TimerExerciseList(exercises: [Exercise.example])
        .preferredColorScheme(.dark)
}
