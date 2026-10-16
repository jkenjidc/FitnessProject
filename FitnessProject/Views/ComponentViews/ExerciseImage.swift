//
//  ExerciseImage.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 10/15/26.
//

import SwiftUI

/// Exercise thumbnail that falls back to a dumbbell icon when there is no image or it fails to load.
struct ExerciseImage: View {
    let url: URL?

    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
            case .empty where url != nil:
                Color.gray
            default:
                Image(systemName: "dumbbell")
                    .resizable()
                    .scaledToFit()
                    .padding(8)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    ExerciseImage(url: nil)
        .frame(width: 50, height: 50)
}
