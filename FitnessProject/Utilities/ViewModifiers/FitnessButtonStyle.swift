//
//  FitnessButtonStyle.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 11/16/25.
//

import Foundation
import SwiftUI

struct FitnessButtonStyle: ButtonStyle {
    let variant: FitnessButtonVariant
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: variant.fontSize))
            .padding(.vertical, variant.verticalPadding)
            .padding(.horizontal, variant.horizontalPadding)
            .overlay(
                RoundedRectangle(cornerRadius: variant.cornerRadius)
                    .stroke(lineWidth: variant.lineWidth)
                    .frame(minWidth: variant.minWidth, maxWidth: .infinity)
            )
            .opacity(configuration.isPressed ? 0.7 : 1.0)
    }
}

extension ButtonStyle where Self == FitnessButtonStyle {
    static func fitness(_ variant: FitnessButtonVariant) -> FitnessButtonStyle {
        FitnessButtonStyle(variant: variant)
    }
}

enum FitnessButtonVariant {
    case primary
    case secondary

    var fontSize: CGFloat {
        switch self {
        case .primary:
            return 30
        case .secondary:
            return 18
        }
    }

    var cornerRadius: CGFloat {
        switch self {
        case .primary:
            return 20
        case .secondary:
            return 16
        }
    }

    var lineWidth: CGFloat {
        switch self {
        case .primary:
            return 4
        case .secondary:
            return 1
        }
    }

    var minWidth: CGFloat {
        switch self {
        case .primary:
            return 250
        case .secondary:
            return 200
        }
    }

    var verticalPadding: CGFloat {
        switch self {
        case .primary:
            return 15
        case .secondary:
            return 8
        }
    }

    var horizontalPadding: CGFloat {
        switch self {
        case .primary:
            return 45
        case .secondary:
            return 30
        }
    }


}
