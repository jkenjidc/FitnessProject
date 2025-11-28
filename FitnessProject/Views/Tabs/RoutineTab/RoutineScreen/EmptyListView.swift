//
//  EmptyListView.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 11/27/25.
//

import SwiftUI

extension RoutinesScreen {
    struct EmptyListView: View {
        var body: some View {
            ContentUnavailableView{
                Image(systemName: "figure.flexibility")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundStyle(.secondary)
            } description: {
                Text("No routines added")
            }
            .overlay(alignment: .bottom) {
                AddRoutineButton()
            }
        }
    }
}

#Preview {
    RoutinesScreen.EmptyListView()
}
