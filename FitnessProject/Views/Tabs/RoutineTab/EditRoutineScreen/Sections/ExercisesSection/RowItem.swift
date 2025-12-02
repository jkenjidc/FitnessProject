//
//  ExerciseRowItem.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 12/1/25.
//

import SwiftUI

extension ExercisesSection {
    struct RowItem: View {
        @Binding var exercise: Exercise
        var onDelete: (Exercise) -> Void

        var body: some View {
            VStack(alignment: .center, spacing: 0){
                Header(name: exercise.name) {
                    onDelete(exercise)
                }

                Grid(exercise: $exercise)
//                if let bestAttemptString = lastBestSetText {
//                    HStack{
//                        Spacer()
//                        Text(bestAttemptString)
//                            .foregroundStyle(.secondary.opacity(0.7))
//                            .padding(.bottom)
//                        Spacer()
//                    }
//                    .frame(maxWidth: .infinity)
//                }

                addSetButton

            }
            .containerRelativeFrame(.horizontal)
            .padding(.bottom, 5)
        }

        @MainActor
        var addSetButton: some View {
            Button {
                let lastWeight = exercise.sets.last?.weight ?? 0
                let lastRep = exercise.sets.last?.reps ?? 0
                exercise.sets.append(ExerciseSet(weight: lastWeight, reps: lastRep))
            } label: {
                Text("Add Set +")
                    .frame(maxWidth: .infinity)
                    .contentShape(Capsule())
                    .background(.secondary)
                    .clipShape(.capsule)
                    .padding(.horizontal, 30)
            }
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    @Previewable @State var previewValue = Exercise.example
    ExercisesSection.RowItem(exercise: $previewValue) { _ in }
}
