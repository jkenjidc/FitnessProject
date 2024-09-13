//
//  ExerciseListCellView.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/13/24.
//

import SwiftUI

struct ExerciseListCellView: View {
    @Binding var exercise: Exercise
    @State var weights:[String] = ["0"]
    @State var reps:[String] = ["0"]
    
    let columns = [
        GridItem(.fixed(80)),
        GridItem(.fixed(80)),
        GridItem(.fixed(80))
    ]
    
    var body: some View {
        VStack(spacing: 0){
            Text(exercise.name)
            LazyVGrid(columns: columns){
                Text("Sets")
                Text("lbs")
                Text("Reps")
                ForEach(0..<exercise.sets.count, id: \.self){ index in
                    Text(String(index+1))
                    TextField("\(weights[index])", text: $weights[index])
                        .multilineTextAlignment(.center)
                    TextField("\(reps[index])", text: $reps[index])
                        .multilineTextAlignment(.center)
                }
                
            }
            .padding(.bottom, 15)
            Button{
                addSet()
            } label: {
                Text("Add Set +")
            }
            .frame(maxWidth: .infinity)
            .buttonStyle(.plain)
            .background(.secondary)
            .clipShape(.capsule)
            .padding(.horizontal, 30)
        }
//        .onAppear(perform: {
//            weights.append(String(exercise.sets.first?.weight ?? 0))
//            reps.append(String(exercise.sets.first?.reps ?? 0))
//        })
    }
    
    func addSet() {
        let lastWeight = exercise.sets.last?.weight ?? 0
        let lastRep = exercise.sets.last?.reps ?? 0
        weights.append(exercise.sets.last?.formattedWeight ?? "")
        reps.append(String(lastRep))
        exercise.sets.append(ExerciseSet(weight: lastWeight, reps: lastRep))

    }
}

#Preview {
    @State var exercise = Exercise(name: "Exercise 1", sets: [ExerciseSet(weight: 0, reps: 0)])
    return ExerciseListCellView(exercise: $exercise)
        .preferredColorScheme(.dark)
}
