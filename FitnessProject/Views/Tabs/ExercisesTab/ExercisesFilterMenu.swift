//
//  ExercisesFilterMenu.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 8/3/25.
//

import SwiftUI

struct ExercisesFilterMenu: View {
    @Environment(ExerciseService.self) var service

    var body: some View {
        HStack(spacing: 5) {
            bodyPartMenu

            targetMuscleMenu
            
            Spacer()
        }

    }

    var bodyPartMenu: some View {
        Menu {
            ForEach(service.exercises.uniqueValues(for: .bodyPart), id: \.self) { bodyPart in
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        if service.selectedBodyPart != bodyPart {
                            service.selectedBodyPart = bodyPart
                        } else {
                            service.selectedBodyPart = nil
                        }
                    }
                } label: {
                    HStack {
                        Text(bodyPart)
                        Spacer()
                        if service.selectedBodyPart == bodyPart {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        } label: {
            Text(service.selectedBodyPart ?? "Body Part")
                .padding(.vertical, 5)
                .padding(.horizontal, 10)
                .background(
                    Capsule().fill(
                        service.selectedBodyPart != nil ? .green :
                        .gray.opacity(0.7)
                    )
                )
//                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(.black)
        }

    }

    var targetMuscleMenu: some View {
        Menu {
            ForEach(service.exercises.uniqueValues(for: .target), id: \.self) { target in
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        if service.selectedTargetMuscle != target {
                            service.selectedTargetMuscle = target
                        } else {
                            service.selectedTargetMuscle = nil
                        }
                    }
                } label: {
                    HStack {
                        Text(target)
                        Spacer()
                        if service.selectedTargetMuscle == target {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        } label: {
            Text(service.selectedTargetMuscle ?? "Target Muscle")
                .padding(.vertical, 5)
                .padding(.horizontal, 10)
                .background(
                    Capsule().fill(
                        service.selectedTargetMuscle != nil ? .green :
                        .gray.opacity(0.7)
                    )
                )
                .foregroundStyle(.black)
        }

    }
}

#Preview {
    ExercisesFilterMenu()
        .injectServices()
}
