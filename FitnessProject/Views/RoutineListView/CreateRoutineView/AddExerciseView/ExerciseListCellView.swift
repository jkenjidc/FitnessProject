//
//  ExerciseListCellView.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/13/24.
//

import SwiftUI

@MainActor
struct exerciseSetListRowView: View {
    @Binding var exercise: Exercise
    @Binding var exerciseSet: ExerciseSet
    var body: some View {
        Group{
            Text(exercise.getSetIndex(exerciseSet: exerciseSet))
            TextField("\(exerciseSet.weight)", value: $exerciseSet.weight, format: .number)
                .multilineTextAlignment(.center)
            TextField("\(exerciseSet.reps)", value: $exerciseSet.reps, format: .number)
                .multilineTextAlignment(.center)
            Button {
                exercise.deleteSet(exerciseSet: exerciseSet)
                
            } label: {
                Image(systemName: "minus.square.fill")
                    .foregroundStyle(Color.red)
            }
            .buttonStyle(.plain)
        }
    }
}

struct ExerciseListCellView: View {
    @Binding var exercise: Exercise
    var deleteExercise: (Exercise) -> Void
    
    let columns = [
        GridItem(.fixed(80)),
        GridItem(.fixed(80)),
        GridItem(.fixed(80)),
        GridItem(.fixed(80))
    ]
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            ZStack(alignment: .leading){
                Button(role: .destructive){
                    withAnimation{
                        self.deleteExercise(exercise)
                    }
                } label: {
                    Image(systemName: "trash.fill")
                }
                .padding(.leading, 30)
                Text(exercise.name)
                    .frame(maxWidth: .infinity)
                    .padding()

            }
            LazyVGrid(columns: columns){
                Text("Sets")
                Text("lbs")
                Text("Reps")
                Text("")
                ForEach($exercise.sets){ exerciseSet in
                    exerciseSetListRowView(exercise: $exercise, exerciseSet: exerciseSet)
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
    return ExerciseListCellView(exercise: $exercise, deleteExercise: dummyfunc.self )
        .preferredColorScheme(.dark)
}
