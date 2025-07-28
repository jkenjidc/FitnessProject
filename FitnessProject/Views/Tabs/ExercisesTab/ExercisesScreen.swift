//
//  ExercisesScreen.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 7/10/25.
//

import SwiftUI

struct ExercisesScreen: View {
    @State var exercises: [ExerciseV2] = []
    @State var searchQuery: String = ""
    @State var selectedBodyPart: String?

    var filteredExercises: [ExerciseV2] {
        var filtered = exercises

        if let selection = selectedBodyPart {
            filtered = exercises.filter( { $0.bodyPart == selection })
        }

        if searchQuery.isEmpty {
            return filtered
        } else {
            return filtered.filter {
                $0.name.lowercased().contains(searchQuery.lowercased())
            }
        }
    }

    var body: some View {
        VStack(spacing: 20) {
            SearchBar(text: $searchQuery, placeholder: "Search for exercises")
            HStack {
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
                    Text(selectedBodyPart ?? "Sort by bodypart")
                        .padding(.vertical, 5)
                        .padding(.horizontal, 10)
                        .background(
                            Capsule().fill(
                                selectedBodyPart != nil ? .green :
                                .gray.opacity(0.7)
                            )
                        )
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(.black)
                }
            }
            ExercisesListView(for: filteredExercises)
                .ignoresSafeArea(edges: .top)
        }
        .overlay {
            noResultsView
        }
        .task {
            await fetchExercises()
        }
        .padding(.horizontal)
    }

    @ViewBuilder
    private var noResultsView: some View {
        if !searchQuery.isEmpty && filteredExercises.isEmpty {                    ContentUnavailableView(
            "No matching exercises found",
            systemImage: "magnifyingglass",
            description: Text("No results for **\(searchQuery)**")
        )
        }
    }

    //TODO: Move this to an exercises service layer
    func fetchExercises() async {
        do {
            if let cachedExercises = URLCache.shared.cachedResponse(for: ExerciseV2Request.request),
               let expirationDate = cachedExercises.userInfo?["expirationDate"] as? Date,
               Date() < expirationDate {
                try fetchCache(cachedExercises)
            } else {
                try await fetchAndCacheExercises()
            }
        } catch {
            Log.error("Failed to fetch exercises: \(error.localizedDescription)")
        }
    }

    func fetchAndCacheExercises() async throws {
        Log.info("Fetching new data for exercises")
        let (data, response) = try await URLSession.shared.data(for: ExerciseV2Request.request)
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
            let initialCache = CachedURLResponse(
                response: httpResponse,
                data: data,
                storagePolicy: .allowed
            )
            var userInfo = initialCache.userInfo ?? [:]
            userInfo["expirationDate"] = Date.nextDayNoonCentralTime()
            let cachedResponse = CachedURLResponse(
                response: initialCache.response,
                data: initialCache.data,
                userInfo: userInfo,
                storagePolicy: initialCache.storagePolicy
            )

            URLCache.shared.storeCachedResponse(cachedResponse, for: ExerciseV2Request.request)
        }

        if let decodedResponse = try? JSONDecoder().decode([ExerciseV2DTO].self, from: data) {
            exercises = decodedResponse.map(ExerciseV2.init)
        }

    }
    func fetchCache(_ cachedResponse: CachedURLResponse) throws {
        Log.info("Using cached response for exercises")
        if let decodedResponse = try? JSONDecoder().decode([ExerciseV2DTO].self, from: cachedResponse.data) {
            exercises = decodedResponse.map(ExerciseV2.init)
        }

    }
}

#Preview {
    ExercisesScreen()
        .preferredColorScheme(.dark)
}
