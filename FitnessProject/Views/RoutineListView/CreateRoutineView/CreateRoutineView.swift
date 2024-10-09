//
//  CreateRoutineView.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/11/24.
//

import SwiftUI

struct CreateRoutineView: View {
    @Environment(Router.self) var router
    @State var viewModel = ViewModel()
    
    init(routine: Routine? = nil) {
        _viewModel = State(initialValue: ViewModel(routine: routine))
    }
    var body: some View {
        Form {
            routineNameView
            dayOfTheWeekPicker
            routineDescriptionView
            exercisesEmbeddedListView
            
            Button {
                router.presentSheet(.addExerciseSheet(viewModel: $viewModel))
            } label: {
                Text("Add Exercise")
                    .frame(maxWidth: .infinity)
            }
        }
        .scrollBounceBehavior(.basedOnSize)
        .navigationBarBackButtonHidden(true)
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
                        Task {
                            await viewModel.saveRoutine()
                        }
                        router.pop()
                    } else {
                        viewModel.checkRoutineName()
                    }
                } label: {
                    Text("Save")
                }
            }
        }
    }
    var routineNameView: some View {
        return Section(header: Text("Routine Name"), footer: ErrorFooterView(invalidField: viewModel.isMissingRoutineName)
        ){
            TextField("", text: $viewModel.routine.name)
                .keyboardType(.asciiCapable)
                .onChange(of: viewModel.routine.name) { _,_ in
                    viewModel.checkRoutineName()
                }
        }
    }
    
    var dayOfTheWeekPicker: some View {
        let daysOfTheWeek = ["M", "T", "W", "T", "F", "S", "S"]
        return Section("Days to do") {
            HStack(spacing: 10){
                Spacer()
                ForEach(0..<daysOfTheWeek.count, id: \.self){ index in
                    Button {
                    } label: {
                        ZStack {
                            Circle()
                                .foregroundStyle(.secondary)
                                .opacity(0.5)
                            
                            Text(daysOfTheWeek[index])
                                .font(.system(size: 15))
                                .foregroundStyle(.white)
                        }
                        .frame(width: 35, height: 35)
                    }
                    .buttonStyle(.plain)
                    
                }
                Spacer()
            }
        }
        .listRowBackground(Color(UIColor.systemGroupedBackground))
    }
    
    var routineDescriptionView: some View {
        return Section("Routine Description"){
            TextEditor(text: $viewModel.routine.description)
                .frame(height: 65)
        }
    }
    
    var exercisesEmbeddedListView: some View {
        return !viewModel.routine.exercises.isEmpty ?
        ScrollView{
            ForEach($viewModel.routine.exercises) { $exercise in
                ExerciseListCellView(exercise: $exercise)
            }
        }
        :
        nil
    }
}


struct alertBodyView: View {
    @Bindable var viewModel: CreateRoutineView.ViewModel
    @Environment(Router.self) var router
    var body: some View {
        if viewModel.cancellationAlert {
            Button("Cancel", role: .cancel){
                viewModel.cancellationAlert = false
            }
        }
        Button("OK", role: (viewModel.cancellationAlert ? .destructive : .none)){
            if viewModel.cancellationAlert {
                router.pop()
            }
        }
    }
}

#Preview {
    @State var routines = Routine.example
    return CreateRoutineView()
        .environment(Router())
}
