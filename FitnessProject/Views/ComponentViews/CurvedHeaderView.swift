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
        let curveDepth: CGFloat = 28
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.maxX, y: 0))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - curveDepth))

        // Adjust the curve
        let controlPoint = CGPoint(x: rect.midX , y: rect.maxY + curveDepth)
        path.addQuadCurve(
            to: CGPoint(x: 0, y: rect.maxY - curveDepth),
            control: controlPoint
        )

        path.closeSubpath()

        return path
    }
}

#Preview {
    CurvedHeaderView()
}
