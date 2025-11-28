//
//  RoutineNameSection.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 11/27/25.
//

import SwiftUI

extension EditRoutineScreen {
    struct NameSection: View {
        @Binding var name: String

        var body: some View {
            // TODO: Handle validation
            Section(header: Text("Routine Name")) {
//                    footer: ErrorFooterView(invalidField: viewModel.isMissingRoutineName)){
                TextField("", text: $name)
                    .keyboardType(.asciiCapable)
//                    .onChange(of: viewModel.routine.name) { _,_ in
//                        viewModel.checkRoutineName()
//                    }
            }
        }
    }
}

#Preview {
    @Previewable @State var previewValue = "Test Routine Name"
    EditRoutineScreen.NameSection(name: $previewValue)
        .preferredColorScheme(.dark)
}
