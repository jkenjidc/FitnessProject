//
//  RowItem+Grid.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 12/1/25.
//

import SwiftUI
extension ExercisesSection.RowItem {
    struct Grid: View {
        @Binding var exercise: Exercise
        let columns = [
            GridItem(.flexible(minimum: 40, maximum: 50)),    // minus button
            GridItem(.flexible(minimum: 40, maximum: 60)),    // set number
            GridItem(.flexible(minimum: 60, maximum: 100)),   // weight
            GridItem(.flexible(minimum: 60, maximum: 100))   // reps
        ]

        var body: some View {
            LazyVGrid(columns: columns, spacing: 10) {
                Text("")
                Text("Sets")
                    .frame(maxWidth: .infinity)
                // TODO: add back in unit switching
                Text("lb")
                    .frame(maxWidth: .infinity)
                Text("Reps")
                    .frame(maxWidth: .infinity)
                ForEach($exercise.sets){ $exerciseSet in
                    Item(exerciseSet: $exerciseSet) {
                        exercise.sets.removeAll(where: { $0.id == exerciseSet.id })
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 15)
        }
    }

    struct Item: View {
        @Binding var exerciseSet: ExerciseSet
        var onDelete: () -> Void
        var body: some View {
            Button {
                onDelete()
            } label: {
                Image(systemName: "minus.square.fill")
                    .foregroundStyle(Color.red)
            }
            .buttonStyle(.plain)

            Text("1")

            TextField("\(exerciseSet.weight)", value: $exerciseSet.weight, format: .number)
                .multilineTextAlignment(.center)
                .keyboardType(.decimalPad)

            TextField("\(exerciseSet.reps)", value: $exerciseSet.reps, format: .number)
                .multilineTextAlignment(.center)
                .keyboardType(.numberPad)

        }
    }
}

#Preview {
    @Previewable @State var previewValue = Exercise.example
    ExercisesSection.RowItem.Grid(exercise: $previewValue)
}
