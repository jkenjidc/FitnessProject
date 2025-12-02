//
//  ExercisesSection.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 12/1/25.
//

import SwiftUI

struct ExercisesSection: View {
    @Binding var exercises: [Exercise]
    var body: some View {
        Section {
            List{
                ForEach($exercises) { $exercise in
                    RowItem(exercise: $exercise) { exerciseToBeDelete in
                        exercises.removeAll(where: { $0.id == exerciseToBeDelete.id })
                    }
                    .listRowSeparator(.hidden)
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var previewValue = [Exercise.example]
    ExercisesSection(exercises: $previewValue)
}
