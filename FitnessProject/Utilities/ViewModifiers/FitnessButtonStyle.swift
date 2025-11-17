//
//  FitnessButtonStyle.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 11/16/25.
//

import Foundation
import SwiftUI

struct FitnessButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 30))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(lineWidth: 4)
                    .frame(width: 250, height: 50)
            )
            .frame(width: 200, height: 50)
            .opacity(configuration.isPressed ? 0.7 : 1.0)
    }
}

extension ButtonStyle where Self == FitnessButtonStyle {
    static var fitness: FitnessButtonStyle {
        FitnessButtonStyle()
    }
}
