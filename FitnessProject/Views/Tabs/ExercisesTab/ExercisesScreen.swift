//
//  ExercisesScreen.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 7/10/25.
//

import SwiftUI

struct ExercisesScreen: View {
    @Environment(ExerciseService.self) var service
    @Environment(Router.self) var router

    var body: some View {
        VStack(spacing: 20) {
            switch service.networkState {
            case .loading:
                ShimmerLoadingView()

            case .loaded where service.filteredExercises.isEmpty:
                searchHeader
                NoResultsView()
                Spacer()

            case .loaded:
                searchHeader
                ExercisesList()
                    .padding(.horizontal)

            case .error:
                //TODO: Handle error state
                Text("error")
                Spacer()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationTitle(router.currentTab.rawValue.capitalized)
        .task {
            await service.fetchExercises()
        }
    }

    private var searchHeader: some View {
        @Bindable var service = service
        return VStack(spacing: 20) {
            SearchBar(
                text: $service.searchQuery,
                placeholder: "Search for exercises"
            )
            ExercisesFilterMenu()
        }
        .padding(.horizontal)
    }
}

extension ExercisesScreen {
    struct NoResultsView: View {
        @Environment(ExerciseService.self) var service

        var body: some View {
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

#Preview {
    ExercisesScreen()
        .injectServices()
        .preferredColorScheme(.dark)
}
