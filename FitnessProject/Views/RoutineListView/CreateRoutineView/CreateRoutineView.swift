//
//  CreateRoutineView.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/11/24.
//

import SwiftUI

struct CreateRoutineView: View {
    @EnvironmentObject var dataManager: DataManager
    @State var viewModel = ViewModel()
    var body: some View {
        NavigationStack{
            Form {
//                TextField("Routine Name", text: $viewModel.routineName)
                Section("Routine Description"){
                    TextEditor(text: $viewModel.routineDescription)
                        .frame(height: 75)
                }
                if !viewModel.routine.exercises.isEmpty {
                    List{
                        ForEach(viewModel.routine.exercises) { exercise in
                            Text(exercise.name)
                        }
                    }
                }
                Button {
                    viewModel.showAddExerciseSheet.toggle()
                } label: {
                    Text("Add Exercise")
                        .frame(maxWidth: .infinity)
                }
            }
            .sheet(isPresented: $viewModel.showAddExerciseSheet) {
                VStack {
                    TextField("Exercise Name", text: $viewModel.newExerciseName)
                    Button {
                        viewModel.saveExercise()
                    } label: {
                        Text("Add Exercise")
                    }
                }
                .presentationDetents([.fraction(0.4), .medium], selection: .constant(.fraction(0.4)))
            }
            .navigationTitle($viewModel.routineName)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dataManager.addRoutine(routine: viewModel.routine)
                    } label: {
                        Text("Save")
                    }
                }
            }
        }
    }
}

#Preview {
    @State var routines = Routine.example
    return CreateRoutineView()
}
