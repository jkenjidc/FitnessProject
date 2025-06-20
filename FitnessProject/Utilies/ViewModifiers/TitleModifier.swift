//
//  TitleModifier.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 6/20/25.
//

import SwiftUI
struct TitleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundStyle(.secondary)
            .bold()
            .font(.headline)
            .padding(.leading, 10)
    }
}

extension View {
    func title() -> some View {
        modifier(TitleModifier())
    }
}
