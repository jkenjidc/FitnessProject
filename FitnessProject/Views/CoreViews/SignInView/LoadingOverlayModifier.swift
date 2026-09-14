//
//  LoadingOverlayModifier.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 11/25/25.
//

import SwiftUI

struct LoadingOverlayModifier: ViewModifier {
    @Binding var callState: InteractiveCallState

    private var isLoading: Bool {
        callState == .loading
    }

    func body(content: Content) -> some View {
        content
            .disabled(isLoading)
            .blur(radius: isLoading ? 3 : 0)
            // `.overlay` rather than wrapping in a ZStack: an overlay takes the
            // content's frame and cannot resize or re-align it, so showing the
            // scrim can never shift the form underneath.
            .overlay {
                if isLoading {
                    ZStack {
                        // Dim rather than lighten — the app is dark, so a white
                        // scrim washes the screen out instead of receding.
                        Color.black.opacity(0.4)
                        ProgressView()
                            .scaleEffect(1.5)
                            .tint(.white)
                    }
                    .ignoresSafeArea()
                    .transition(.opacity)
                }
            }
            .animation(.easeInOut(duration: 0.2), value: isLoading)
    }
}

extension View {
    /// Dims and blocks the view while a call is in flight.
    ///
    /// Apply this *after* any padding or frame that defines the screen's bounds,
    /// otherwise the scrim is inset by that padding and leaves visible edges.
    func loadingOverlay(_ callState: Binding<InteractiveCallState>) -> some View {
        self.modifier(LoadingOverlayModifier(callState: callState))
    }
}
