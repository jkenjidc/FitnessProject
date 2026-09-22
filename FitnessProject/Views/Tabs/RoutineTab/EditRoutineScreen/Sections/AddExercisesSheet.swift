//
//  AddExercisesSheet.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 12/1/25.
//

import SwiftUI

struct AddExercisesSheet: View {
    @Binding var exercises: [ExerciseEntry]
    @Environment(Router.self) var router
    @Environment(ExerciseService.self) var service

    var body: some View {
        @Bindable var service = service
        VStack(spacing: 15) {
            SearchBar(
                text: $service.searchQuery,
                placeholder: "Search for exercises"
            )

            ExercisesFilterMenu()

            content
        }
        .padding(.horizontal)
        .padding(.top, 20)
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
        // The catalog is fetched lazily, so it may not be loaded if the user came
        // straight to a routine without opening the Exercises tab.
        .task {
            await service.fetchExercises()
        }
    }

    @ViewBuilder
    private var content: some View {
        switch service.networkState {
        case .loading:
            ShimmerLoadingView()

        case .loaded:
            ExercisesList { selected in
                exercises.append(ExerciseEntry(from: selected))
                router.dismissSheet()
            }
            .overlay {
                if service.filteredExercises.isEmpty {
                    ContentUnavailableView(
                        "No matching exercises found",
                        systemImage: "magnifyingglass",
                        description: Text(
                            service.searchQuery.isEmpty
                            ? "No results for selected filters"
                            : "No results for **\(service.searchQuery)**"
                        )
                    )
                }
            }

        case .error:
            ContentUnavailableView(
                "Couldn't load exercises",
                systemImage: "wifi.exclamationmark",
                description: Text("Check your connection and try again.")
            )
            Spacer()
        }
    }
}

#Preview {
    @Previewable @State var previewValue = [ExerciseEntry.example]
    AddExercisesSheet(exercises: $previewValue)
        .injectServices()
        .preferredColorScheme(.dark)
}
