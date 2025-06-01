//
//  CurvedHeaderView.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 6/1/25.
//

import SwiftUI

struct CurvedHeaderView: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        // Start from top-left
        path.move(to: CGPoint(x: 0, y: 0))

        // Draw lines to form the rectangle
        path.addLine(to: CGPoint(x: rect.maxX, y: 0))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - 50))

        // Add the curved bottom
        path.addQuadCurve(
            to: CGPoint(x: 0, y: rect.maxY - 50),
            control: CGPoint(x: rect.width / 2, y: rect.maxY)
        )

        // Close the path
        path.closeSubpath()

        return path
    }
}

#Preview {
    CurvedHeaderView()
}
