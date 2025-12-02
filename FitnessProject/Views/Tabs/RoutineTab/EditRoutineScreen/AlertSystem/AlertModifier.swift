//
//  AlertModifier.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 11/28/25.
//

import Foundation
import SwiftUI

struct AlertModifier: ViewModifier {
    @Binding var shouldPresent: Bool
    @Environment(\.dismiss) var dismiss
    let alert: ActiveAlert?
    func body(content: Content) -> some View {
        // TODO: avoid conditional modifiers
        if let alert {
            content
                .alert(
                    alert.title,
                    isPresented: $shouldPresent,
                ) {
                    Button(alert.primaryButtonTitle, role: .destructive) {
                        alert.primaryButtonAction()
                    }
                    .tint(.red) // TODO: Figure out why this doesnt work
                } message: {
                    Text(alert.message)
                }
        } else {
            content
        }
    }

    // TODO: Refactor to be tint instead
    func buttonTint(for type: AlertTypeV2) -> Color {
        switch type {
        case .normal:
                .accentColor
        case .destructive:
                .red
        }
    }
}

extension View {
    func fitnessAlert(shouldPresent: Binding<Bool>, alert: ActiveAlert?) -> some View {
        modifier(AlertModifier(shouldPresent: shouldPresent, alert: alert))
    }
}
