//
//  ExercisesFilterMenu.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 8/3/25.
//

import SwiftUI

struct ExercisesFilterMenu: View {
    @Binding var selectedBodyPart: String?
    @Binding var selectedTargetMuscle: String?
    let exercises: [ExerciseV2]

    init (
        exercises: [ExerciseV2],
        bodyPart selectedBodyPart: Binding<String?>,
        targetMuscle selectedTargetMuscle: Binding<String?>
    ) {
        self.exercises = exercises
        self._selectedBodyPart = selectedBodyPart
        self._selectedTargetMuscle = selectedTargetMuscle
    }
    var body: some View {
        HStack(spacing: 5) {
            bodyPartMenu

            targetMuscleMenu
            
            Spacer()
        }

    }

    var bodyPartMenu: some View {
        Menu {
            ForEach(exercises.uniqueValues(for: .bodyPart), id: \.self) { bodyPart in
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        if selectedBodyPart != bodyPart {
                            selectedBodyPart = bodyPart
                        } else {
                            selectedBodyPart = nil
                        }
                    }
                } label: {
                    HStack {
                        Text(bodyPart)
                        Spacer()
                        if selectedBodyPart == bodyPart {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        } label: {
            Text(selectedBodyPart ?? "Body Part")
                .padding(.vertical, 5)
                .padding(.horizontal, 10)
                .background(
                    Capsule().fill(
                        selectedBodyPart != nil ? .green :
                        .gray.opacity(0.7)
                    )
                )
//                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(.black)
        }

    }

    var targetMuscleMenu: some View {
        Menu {
            ForEach(exercises.uniqueValues(for: .target), id: \.self) { target in
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        if selectedTargetMuscle != target {
                            selectedTargetMuscle = target
                        } else {
                            selectedTargetMuscle = nil
                        }
                    }
                } label: {
                    HStack {
                        Text(target)
                        Spacer()
                        if selectedTargetMuscle == target {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        } label: {
            Text(selectedTargetMuscle ?? "Target Muscle")
                .padding(.vertical, 5)
                .padding(.horizontal, 10)
                .background(
                    Capsule().fill(
                        selectedTargetMuscle != nil ? .green :
                        .gray.opacity(0.7)
                    )
                )
//                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(.black)
        }

    }
}

#Preview {
    ExercisesFilterMenu(exercises: ExerciseV2.mockList, bodyPart: .constant("waist"), targetMuscle: .constant("abs"))
}
