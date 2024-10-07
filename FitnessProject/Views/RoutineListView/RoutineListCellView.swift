//
//  RoutineListCellView.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/11/24.
//

import SwiftUI

struct RoutineListCellView: View {
    var title: String
    @State private var isExpanded = false
    var body: some View {
        Text(title)
        .padding()
    }
}

#Preview {
    RoutineListCellView(title: "Routine 1")
}
