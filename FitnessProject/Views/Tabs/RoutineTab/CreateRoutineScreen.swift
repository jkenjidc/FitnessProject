//
//  CreateRoutineView.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/11/24.
//

import SwiftUI

struct CreateRoutineScreen: View {
    @Environment(Router.self) var router
    @State var viewModel = ViewModel()
    
    init(routine: Routine? = nil, screenMode: ScreenMode? = .creation) {
        _viewModel = State(initialValue: ViewModel(routine: routine, screenMode: screenMode))
    }
    
    var body: some View {
        Form {
            routineNameView
            dayOfTheWeekPicker
            routineDescriptionView
            timerDisplay
            exercisesEmbeddedListView
            addExerciseButton
        }
        .navigationTitle($viewModel.routine.name)
        .navigationBarTitleDisplayMode(.inline)
        .scrollBounceBehavior(.basedOnSize)
        .navigationBarBackButtonHidden(true)
        .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert) {
            alertBodyView(viewModel: viewModel)
        } message: {
            Text(viewModel.alertMessage)
        }
        .toolbar{
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    viewModel.confirmCancelCreation()
                } label: {
                    Text("Cancel")
                        .foregroundStyle(.red)
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.trailingTabBarItemAction(action: router.pop)
                } label: {
                    Text(viewModel.timerMode ? "Finish" : "Save")
                        .tint(viewModel.timerMode ? .green : nil)
                }
            }
        }
    }
    var routineNameView: some View {
        return !viewModel.timerMode ? 
        Section(header: Text("Routine Name"), 
                footer: ErrorFooterView(invalidField: viewModel.isMissingRoutineName)){
            TextField("", text: $viewModel.routine.name)
                .keyboardType(.asciiCapable)
                .onChange(of: viewModel.routine.name) { _,_ in
                    viewModel.checkRoutineName()
                }
        }
        :
        nil
    }
    
    var dayOfTheWeekPicker: some View {
        return !viewModel.timerMode ? 
        Section(header: Text("Days to do"),
                footer: Text(viewModel.selectedDaysFooterText)) {
            HStack(spacing: 10){
                Spacer()
                ForEach(0..<7, id: \.self){ index in
                    Button {
                        viewModel.selectDay(index: index)
                    } label: {
                        ZStack {
                            Circle()
                                .foregroundStyle(viewModel.selectedDays[index] ? .green : .secondary)
                                .opacity(0.5)
                            
                            Text(viewModel.daysOfTheWeek[index].first!.description)
                                .font(.system(size: 15))
                                .foregroundStyle(.white)
                        }
                        .frame(width: 38, height: 38)
                    }
                    .buttonStyle(.plain)
                    
                }
                Spacer()
            }
        }
        .listRowBackground(Color(UIColor.systemGroupedBackground))
        :
        nil
    }
    
    var routineDescriptionView: some View {
        return !(viewModel.timerMode && viewModel.routine.description.isEmpty) ?
            Section("Routine Description"){
            TextEditor(text: $viewModel.routine.description)
                .frame(height: 65)
        }
        : nil
    }
    
    var timerDisplay: some View {
        return viewModel.timerMode ?
        VStack(spacing: 5){
            HStack{
                Spacer()
                Text("\(viewModel.timeString)")
                    .font(.system(size: 45))
                    .multilineTextAlignment(.center)
                    .onReceive(viewModel.timer){ timer in
                        guard viewModel.isTimerActive else { return }
                        viewModel.elapsedTime += 1
                    }
                Spacer()
            }
            Button{
                viewModel.isTimerActive.toggle()
            } label: {
                Image(systemName: viewModel.isTimerActive ? "pause.fill" : "play.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .scaledToFit()
                    .foregroundStyle(.black)
                    .padding(5)
                    .frame(maxWidth: .infinity)
                    .background((viewModel.isTimerActive ? Color.secondary : Color.green))
                    .clipShape(.capsule)
            }
            .padding(.horizontal)
        }
        :
        nil
            
    }
    
    var exercisesEmbeddedListView: some View {
        return !viewModel.routine.exercises.isEmpty ?
        List{
            ForEach($viewModel.routine.exercises) { $exercise in
                ExerciseListCellView(exercise: $exercise, screenMode: viewModel.currentScreenMode, deleteExercise: self.viewModel.confirmDeleteExerise)
                    .transition(.move(edge: .top))
                    .listRowSeparator(.hidden)
            }
        }
        .scrollBounceBehavior(.basedOnSize)
        :
        nil
    }
    
    var addExerciseButton: some View {
        return Button {
            router.presentSheet(.addExerciseSheet(viewModel: $viewModel))
        } label: {
            Text("Add Exercise")
                .frame(maxWidth: .infinity)
        }
    }
}


struct alertBodyView: View {
    @Bindable var viewModel: CreateRoutineScreen.ViewModel
    @Environment(Router.self) var router
    var body: some View {
        Button("Cancel", role: .cancel){}
        switch viewModel.currentAlertType {
        case .cancelCreation:
            Button("OK", role: (.destructive)){
                router.pop()
            }
        case .exerciseDeletion:
            Button("Delete", role: (.destructive)){
                if let exercise = viewModel.currentExercise {
                    viewModel.deleteExercise(exercise: exercise)
                }
            }
        case .routineCompletion:
            Button(){
                viewModel.finishRoutine()
                router.pop()
            } label: {
                Text("Finish")
            }
        }
    }
}

#Preview {
    return CreateRoutineScreen()
        .environment(Router())
}
