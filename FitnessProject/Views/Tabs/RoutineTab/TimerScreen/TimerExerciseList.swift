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
                listHeader
                VStack {
                    ForEach(exercises) { exercise in
                        //Necessary step because we are using mock data with the same ID
                        ExerciseListRow(exercise)
                    }
                }
            }
            .padding(.vertical, 15)
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
                VStack {
                    HStack {
                        Text("Weight")
                        Spacer()
                        Text("Reps")
                    }
                    ForEach($exercise.sets) { $exerciseSet in
                        HStack {
                            TextField("\(exerciseSet.weight)", value: $exerciseSet.weight, format: .number)
                                .keyboardType(.decimalPad)
                            Spacer()
                            TextField("\(exerciseSet.reps)", value: $exerciseSet.reps, format: .number)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.trailing)
                        }

                    }
                }
                .padding(.horizontal, 25)
                .padding()

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
                .padding()

            }
            .background(.blue.opacity(0.7))
            .cornerRadius(10)
            .foregroundColor(.white)
            .padding(.bottom, 10)
            .tint(.clear)
        }
    }
}

#Preview {
    TimerScreen.TimerExerciseList(exercises: [Exercise.example])
        .preferredColorScheme(.dark)
}
