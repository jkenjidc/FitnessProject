//
//  AddExerciseView.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 10/3/24.
//

import SwiftUI

struct AddExerciseView: View {
    @Binding var viewModel: CreateRoutineView.ViewModel
    var body: some View {
        VStack {
            VStack(alignment: .leading){
                EntryFieldView(textBinding: $viewModel.newExerciseName, placeholderString: "Exercise Name")
                    .padding(.horizontal, 15)
                    .onChange(of: viewModel.newExerciseName){ _,_ in
                        viewModel.isMissingExerciseName = viewModel.newExerciseName.isEmpty
                    }
                ErrorFooterView(invalidField: viewModel.isMissingExerciseName)
                    .padding(.leading, 25)
            }
            Button {
                !viewModel.newExerciseName.isEmpty ? viewModel.saveExercise() : viewModel.checkInputs()
            } label: {
                Text("Add Exercise")
            }
            .onDisappear(perform: {
                viewModel.isMissingExerciseName = false
            })
        }
        .presentationDetents([.fraction(0.4), .medium], selection: .constant(.fraction(0.4)))
    }
}

#Preview {
    AddExerciseView(viewModel: .constant(CreateRoutineView.ViewModel()))
}
