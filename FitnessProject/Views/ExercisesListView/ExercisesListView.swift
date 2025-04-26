//
//  ExercisesListView.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 4/9/25.
//

import SwiftUI
import Foundation

struct ExercisesListView: View {
    @State var exercises: [ExerciseV2] = []
    var body: some View {
        List {
            ForEach(exercises) { exercise in
                HStack {
                    AsyncImage(url: exercise.gifUrl) { image in
                        image
                            .resizable()
                    } placeholder: {
                        Color.gray
                    }
                    .frame(width: 50, height: 50)
                    Text(exercise.name)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 30)
                }
                .padding(.bottom, 15)
            }
        }
        .task {
            await fetchExercises()
        }
    }
    func fetchExercises() async {
        do {
            if let cachedExercises = URLCache.shared.cachedResponse(for: ExerciseV2Request.request),let expirationDate = cachedExercises.userInfo?["expirationDate"] as? Date,
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
            let cachedResponse = CachedURLResponse(response: initialCache.response, data: initialCache.data, userInfo: userInfo, storagePolicy: initialCache.storagePolicy)

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
    ExercisesListView()
        .preferredColorScheme(.dark)
}
