//
//  DescriptionSection.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 11/27/25.
//

import SwiftUI

extension EditRoutineScreen {
    struct DescriptionSection: View {
        @Binding var description: String
        var body: some View {
            Section("Routine Description"){
                TextEditor(text: $description)
                    .frame(height: 65)
            }
        }
    }
}

#Preview {
    @Previewable @State var previewValue = "Routine description"
    EditRoutineScreen.DescriptionSection(description: $previewValue)
}
