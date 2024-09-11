//
//  CreateRoutineViewModel.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/11/24.
//

import Foundation


extension CreateRoutineView {
    @Observable
    class ViewModel {
        var routine: Routine = Routine()
        var routineName = "Routine Name"
        var routineDescription = ""
        var showAddExerciseSheet = false
        var newExerciseName = ""
        
        func saveExercise() {
            let exercise = Exercise(name: newExerciseName, description: "", stats: Stats.example, sets: [])
            routine.exercises.append(exercise)
            routine.name = routineName
            showAddExerciseSheet.toggle()
            newExerciseName = ""
        }
    }
}
