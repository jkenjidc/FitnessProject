//
//  ExerciseDetailSheet.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 8/28/25.
//

import SwiftUI

struct ExerciseDetailSheet: View {
    @Environment(\.dismiss) var dismiss
    let exercise: ExerciseV2
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 10) {
                    ExerciseImage(url: exercise.imageURL)
                        .frame(width: 250, height: 180)

                    HStack {
                        ForEach(exercise.accessoryLabels, id: \.self) { label in
                            Text(label)
                                .capsuleStyle()
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(exercise.instructions.indices, id: \.self) { index in
                            HStack(alignment: .top, spacing: 8) {
                                Text("\(index + 1).")

                                Text(exercise.instructions[index])
                                    .multilineTextAlignment(.leading)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }

                    Text("Exercise data from [wger.de](https://wger.de) (CC-BY-SA)")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .padding(.top, 8)
                }
                .padding(.horizontal, 16)
            }
            .toolbar {
                ToolbarItem(placement: .principal){
                    Text(exercise.name)
                        .font(.system(size: 25, weight: .bold))
                }

                ToolbarItem(placement: .topBarTrailing){
                    Button("close sheet", systemImage: "xmark", action: { dismiss() })
                        .buttonStyle(.plain)
                }
            }
            .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    ExerciseDetailSheet(exercise: ExerciseV2.mock)
}
