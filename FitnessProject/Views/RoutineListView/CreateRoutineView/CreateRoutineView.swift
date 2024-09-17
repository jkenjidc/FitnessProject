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
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack{
            Form {
                Section(header: Text("Routine Name"), footer: errorFooterView(invalidField: viewModel.isMissingRoutineName)){
                    TextField("", text: $viewModel.routine.name)
                        .keyboardType(.asciiCapable)
                        .onChange(of: viewModel.routine.name) { _,_ in
                            viewModel.isMissingRoutineName = viewModel.routine.name.isEmpty
                        }
                }
                
                Section("Routine Description"){
                    TextEditor(text: $viewModel.routine.description)
                        .frame(height: 75)
                }
                if !viewModel.routine.exercises.isEmpty {
                    ScrollView{
                        ForEach($viewModel.routine.exercises) { $exercise in
                            ExerciseListCellView(exercise: $exercise)
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
            .navigationBarBackButtonHidden(true)
            .sheet(isPresented: $viewModel.showAddExerciseSheet) {
                VStack {
                    VStack(alignment: .leading){
                        TextField("Exercise Name", text: $viewModel.newExerciseName)
                            .padding()
                            .overlay (
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(.secondary)
                            )
                            .padding(.horizontal, 15)
                            .onChange(of: viewModel.newExerciseName){ _,_ in
                                viewModel.isMissingExerciseName = viewModel.newExerciseName.isEmpty
                            }
                        errorFooterView(invalidField: viewModel.isMissingExerciseName)
                            .padding(.leading, 25)
                    }
                    Button {
                        if !viewModel.isMissingExerciseName {
                            viewModel.saveExercise()
                        } else {
                            viewModel.isMissingExerciseName = viewModel.newExerciseName.isEmpty
                        }
                    } label: {
                        Text("Add Exercise")
                    }
                }
                .presentationDetents([.fraction(0.4), .medium], selection: .constant(.fraction(0.4)))
            }
            .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert) {
                alertBodyView(viewModel: $viewModel)
            } message: {
                Text(viewModel.alertMessage)
            }
            .navigationTitle($viewModel.routine.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        viewModel.cancelCreation()
                    } label: {
                        Text("Cancel")
                            .foregroundStyle(.red)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        if viewModel.validInputs {
                            dataManager.addRoutine(routine: viewModel.routine)
                            dismiss()
                        } else {
                            viewModel.isMissingRoutineName = viewModel.routine.name.isEmpty
                        }
                    } label: {
                        Text("Save")
                    }
                }
            }
        }
        
    }
}

struct errorFooterView: View {
    var invalidField: Bool
    var body: some View {
        if invalidField {
            Text("Field can't be blank")
                .foregroundStyle(.red)
                .opacity(0.8)
        }
    }
}

struct alertBodyView: View {
    @Binding var viewModel: CreateRoutineView.ViewModel
    @Environment(\.dismiss) var dismiss
    var body: some View {
        if viewModel.cancellationAlert {
            Button("Cancel", role: .cancel){
                viewModel.cancellationAlert = false
            }
        }
        Button("OK", role: (viewModel.cancellationAlert ? .destructive : .none)){
            if viewModel.cancellationAlert {
                dismiss()
                viewModel.cancellationAlert = false
            }
        }
    }
}

#Preview {
    @State var routines = Routine.example
    return CreateRoutineView()
        .environmentObject(DataManager())
}
