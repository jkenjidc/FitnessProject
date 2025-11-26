//
//  LoadingOverlayModifier.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 11/25/25.
//

import SwiftUI

// TODO: Fix horizontal padding issue
struct LoadingOverlayModifier: ViewModifier {
    @Binding var callState: InteractiveCallState

    private var isLoading: Bool {
        callState == .loading
    }

    func body(content: Content) -> some View {
        ZStack {
            content
                .disabled(isLoading)
                .blur(radius: isLoading ? 3 : 0)

            if isLoading {
                Color.white.opacity(0.25)
                    .ignoresSafeArea(edges: .all)

                ProgressView()
                    .scaleEffect(1.5)
                    .tint(.white)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isLoading)
    }
}

extension View {
    func loadingOverlay(_ callState: Binding<InteractiveCallState>) -> some View {
        self.modifier(LoadingOverlayModifier(callState: callState))
    }
}
