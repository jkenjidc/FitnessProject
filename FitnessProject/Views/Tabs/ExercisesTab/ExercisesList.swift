//
//  ExercisesListView.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 4/9/25.
//

import SwiftUI
import Foundation

struct ExercisesList: View {
    @Environment(ExerciseService.self) var service
    @Environment(Router.self) var router

    var body: some View {
        List {
            ForEach(service.filteredExercises) { exercise in
                Button {
                    router.presentSheet(.exerciseDetail(exercise))
                } label: {
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
                }
                .listRowInsets(EdgeInsets(top: 15, leading: 0, bottom: 15, trailing: 0))
            }
        }
        .listStyle(.plain)

    }
}

#Preview {
    ExercisesList()
        .injectServices()
        .preferredColorScheme(.dark)
}
