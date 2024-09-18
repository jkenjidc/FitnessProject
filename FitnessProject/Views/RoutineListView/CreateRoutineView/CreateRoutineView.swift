//
//  CreateRoutineView.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/11/24.
//

import SwiftUI

struct CreateRoutineView: View {
    @EnvironmentObject var appState: AppState
    @StateObject var viewModel = ViewModel()
    @Environment(\.dismiss) var dismiss
    
    var routineNameView: some View {
        return Section(header: Text("Routine Name"), footer: errorFooterView(invalidField: viewModel.isMissingRoutineName)){
            TextField("", text: $viewModel.routine.name)
                .keyboardType(.asciiCapable)
                .onChange(of: viewModel.routine.name) { _,_ in
                    viewModel.checkInputs()
                }
        }
    }
    
    var routineDescriptionView: some View {
        return Section("Routine Description"){
            TextEditor(text: $viewModel.routine.description)
                .frame(height: 75)
        }
    }
    
    var exercisesEmbeddedListView: some View {
        return !viewModel.routine.exercises.isEmpty ?
            ScrollView{
                ForEach($viewModel.routine.exercises) { $exercise in
                    ExerciseListCellView(exercise: $exercise)
                }
                .scrollBounceBehavior(.basedOnSize)
            }
        :
            nil
    }
    
    var addExerciseSheetView: some View {
        return VStack {
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
    var body: some View {
        NavigationStack{
            Form {
                routineNameView
                routineDescriptionView
                exercisesEmbeddedListView
                
                Button {
                    viewModel.showAddExerciseSheet.toggle()
                } label: {
                    Text("Add Exercise")
                        .frame(maxWidth: .infinity)
                }
            }
            .scrollBounceBehavior(.basedOnSize)
            .navigationBarBackButtonHidden(true)
            .sheet(isPresented: $viewModel.showAddExerciseSheet) {
                addExerciseSheetView
            }
            .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert) {
                alertBodyView(viewModel: viewModel)
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
                            appState.addRoutine(routine: viewModel.routine)
                            dismiss()
                        } else {
                            viewModel.checkInputs()
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
    @Bindable var viewModel: CreateRoutineView.ViewModel
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
            }
        }
    }
}

#Preview {
    @State var routines = Routine.example
    return CreateRoutineView()
        .environmentObject(AppState())
}
