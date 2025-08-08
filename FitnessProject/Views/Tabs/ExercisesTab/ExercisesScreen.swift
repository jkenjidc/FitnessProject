//
//  ExercisesScreen.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 7/10/25.
//

import SwiftUI

struct ExercisesScreen: View {
    @Environment(ExerciseService.self) var service

    var body: some View {
        @Bindable var service = service
        VStack(spacing: 20) {
            SearchBar(
                text: $service.searchQuery,
                placeholder: "Search for exercises"
            )

            ExercisesFilterMenu()

            ExercisesListView()
        }
        .overlay {
            noResultsView
        }
        .task {
            await service.fetchExercises()
        }
        .padding(.horizontal)
    }

    @ViewBuilder
    private var noResultsView: some View {
        if !service.searchQuery.isEmpty && service.filteredExercises.isEmpty {                    ContentUnavailableView(
            "No matching exercises found",
            systemImage: "magnifyingglass",
            description: Text("No results for **\(service.searchQuery)**")
        )
        }
    }
}

#Preview {
    ExercisesScreen()
        .injectServices()
        .preferredColorScheme(.dark)
}
