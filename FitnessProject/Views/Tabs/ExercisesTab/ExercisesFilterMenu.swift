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
            ForEach(service.bodyPartOptions, id: \.self) { bodyPart in
                Button {
                    if service.selectedBodyPart != bodyPart {
                        service.selectedBodyPart = bodyPart
                    } else {
                        service.selectedBodyPart = nil
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
                .capsuleStyle(
                    backgroundColor:
                        service.selectedBodyPart != nil ? .green : .gray.opacity(0.7)
                )
        }
        .buttonStyle(.plain)
    }

    var targetMuscleMenu: some View {
        Menu {
            ForEach(service.equipmentOptions, id: \.self) { equipment in
                Button {
                    if service.selectedEquipment != equipment {
                        service.selectedEquipment = equipment
                    } else {
                        service.selectedEquipment = nil
                    }
                } label: {
                    HStack {
                        Text(equipment)
                        Spacer()
                        if service.selectedEquipment == equipment {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        } label: {
            Text(service.selectedEquipment ?? "Equipment")
                .capsuleStyle(
                    backgroundColor:
                        service.selectedEquipment != nil ? .green : .gray.opacity(0.7)
                )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ExercisesFilterMenu()
        .injectServices()
}
