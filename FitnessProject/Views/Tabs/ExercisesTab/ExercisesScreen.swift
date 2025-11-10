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
        VStack(spacing: 20) {
            @Bindable var service = service
            SearchBar(
                text: $service.searchQuery,
                placeholder: "Search for exercises"
            )

            switch service.networkState {
            case .loading:
                ShimmerLoadingView()

            case .loaded:
                Content()

            case .error:
                //TODO: Handle error state
                Text("error")
                Spacer()
            }
        }
    }
}

extension ExercisesScreen {
    struct Content: View {
        @Environment(ExerciseService.self) var service
        var body: some View {
            VStack(spacing: 20) {
                ExercisesFilterMenu()

                ExercisesList()
            }
            .overlay {
                noResultsView
            }
            .padding(.horizontal)
        }

        @ViewBuilder
        private var noResultsView: some View {
            if service.filteredExercises.isEmpty {
                ContentUnavailableView(
                    "No matching exercises found",
                    systemImage: "magnifyingglass",
                    description: Text(
                        service.searchQuery.isEmpty ? "No results for selected filters" : "No results for **\(service.searchQuery)**"
                    )
                )
            }
        }
    }

}

#Preview {
    ExercisesScreen()
        .injectServices()
        .preferredColorScheme(.dark)
}
