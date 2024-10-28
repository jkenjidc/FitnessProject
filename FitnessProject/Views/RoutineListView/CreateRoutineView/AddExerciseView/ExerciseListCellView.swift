//
//  ExerciseListCellView.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/13/24.
//

import SwiftUI

struct exerciseSetListRowView: View {
    @Binding var exercise: Exercise
    @Binding var exerciseSet: ExerciseSet
    @State private var completed = false
    var timerMode: Bool
    var body: some View {
        Group{
            Button {
                exercise.deleteSet(exerciseSet: exerciseSet)
            } label: {
                Image(systemName: "minus.square.fill")
                    .foregroundStyle(Color.red)
            }
            .buttonStyle(.plain)
            Text(exercise.getSetIndex(exerciseSet: exerciseSet))
            TextField("\(exerciseSet.weight)", value: $exerciseSet.weight, format: .number)
                .multilineTextAlignment(.center)
            TextField("\(exerciseSet.reps)", value: $exerciseSet.reps, format: .number)
                .multilineTextAlignment(.center)
            if timerMode {
                Image(systemName: ( completed ? "checkmark.square.fill" : "square"))
                    .foregroundStyle(.green)
                    .onTapGesture {
                        completed.toggle()
                    }
            } else {
                Text("")
                    .frame(width: 25)
            }
        }
    }
}

struct ExerciseListCellView: View {
    @Binding var exercise: Exercise
    @Bindable var dataManager = DataManager.shared
    var screenMode: ScreenMode
    var timerMode: Bool {
        return screenMode == .timer
    }
    var deleteExercise: (Exercise) -> Void
    let columns = [
        GridItem(.fixed(80)),
        GridItem(.fixed(80)),
        GridItem(.fixed(80)),
        GridItem(.fixed(80)),
        GridItem(.fixed(80))
        
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            ZStack(alignment: .leading){
                Image(systemName: "trash.fill")
                    .foregroundStyle(.red)
                    .onTapGesture {
                        withAnimation{
                            self.deleteExercise(exercise)
                        }
                    }
                    .padding(.leading, 30)
                
                Text(exercise.name)
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            
            LazyVGrid(columns: columns){
                Text("")
                Text("Sets")
                Text("\(dataManager.user.preferences.usingImperialWeightUnits ? "lbs" : "kg")")
                Text("Reps")
                Text("")
                ForEach($exercise.sets){ exerciseSet in
                    exerciseSetListRowView(exercise: $exercise, exerciseSet: exerciseSet, timerMode: timerMode)
                }
            }
            .padding(.bottom, 15)
            
            Button{
                addSet()
            } label: {
                Text("Add Set +")
                    .frame(maxWidth: .infinity)
                    .contentShape(Capsule())
                    .background(.secondary)
                    .clipShape(.capsule)
                    .padding(.horizontal, 30)
            }
            .buttonStyle(.plain)
        }
        .padding(.bottom, 5)
    }
    
    func addSet() {
        let lastWeight = exercise.sets.last?.weight ?? 0
        let lastRep = exercise.sets.last?.reps ?? 0
        exercise.sets.append(ExerciseSet(weight: lastWeight, reps: lastRep))
    }
}

#Preview {
    @State var exercise = Exercise(name: "Exercise 1", sets: [ExerciseSet(weight: 0, reps: 0)])
    func dummyfunc(exerise: Exercise){}
    return ExerciseListCellView(exercise: $exercise, screenMode: .creation, deleteExercise: dummyfunc.self)
        .preferredColorScheme(.dark)
}

