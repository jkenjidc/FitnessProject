//
//  ExercisesListView.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 4/9/25.
//

import SwiftUI

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
        .onAppear {
            Task {
                do {
                    let (data, _) = try await URLSession.shared.data(for: ExerciseV2Request.request)
                    if let decodedResponse = try? JSONDecoder().decode([ExerciseV2DTO].self, from: data) {
                        exercises = decodedResponse.map(ExerciseV2.init)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

#Preview {
    ExercisesListView()
        .preferredColorScheme(.dark)
}
