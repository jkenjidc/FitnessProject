//
//  HighlightedSection.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 11/27/25.
//

import SwiftUI

extension RoutinesScreen {
    struct HighlightedSection: View {
        @Environment(RoutineService.self) var routineService

        var body: some View {
            if !routineService.routinesOfTheDay.isEmpty {
                VStack(alignment: .leading){
                    Text("ROUTINE FOR TODAY")
                        .foregroundStyle(.secondary)
                        .bold()
                        .font(.headline)
                        .padding(.leading, 32)
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(alignment: .center){
                            ForEach(routineService.routinesOfTheDay) { routine in
                                StartRoutineCircleGraphic(routineId: routine.id)
                            }
                        }
                        .scrollTargetLayout()
                    }
                    .transition(.scale)
                    .scrollTargetBehavior(.paging)
                    .scrollBounceBehavior(.basedOnSize)
                }
            }
        }
    }
}

#Preview {
    RoutinesScreen.HighlightedSection()
}
