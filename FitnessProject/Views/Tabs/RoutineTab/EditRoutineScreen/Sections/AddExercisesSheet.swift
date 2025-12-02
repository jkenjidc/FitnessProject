//
//  AddExercisesSheet.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 12/1/25.
//

import SwiftUI

struct AddExercisesSheet: View {
    @Binding var exercises: [Exercise]
    @Environment(Router.self) var router
    @State var name: String = ""
    var body: some View {
        VStack {
            VStack(alignment: .leading){
                EntryFieldView(
                    textBinding: $name,
                    placeholderString: "Exercise Name"
                )
                    .padding(.horizontal, 15)
                // TODO: Add back in error view
//                ErrorFooterView(invalidField: viewModel.isMissingExerciseName)
//                    .padding(.leading, 25)
            }
            Button {
                router.dismissSheet()
                exercises.append(.init(name: name, sets: []))
            } label: {
                Text("Add Exercise")
            }
            .disabled(name.isEmpty)
            .buttonStyle(.fitness(.secondary))
        }
        .presentationDetents([.fraction(0.4), .medium], selection: .constant(.fraction(0.4)))
    }
}

#Preview {
    @Previewable @State var previewValue = [Exercise.example]
    AddExercisesSheet(exercises: $previewValue)
}
