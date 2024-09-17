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
        var showAddExerciseSheet = false
        var newExerciseName = ""
        var showAlert = false
        var alertMessage = ""
        var alertTitle = ""
        var cancellationAlert = false
        var isMissingRoutineName: Bool = false
        var isMissingExerciseName: Bool = false
        
        var validInputs: Bool {
            return !routine.name.isEmpty
        }
        
        func saveExercise() {
            let exercise = Exercise(name: newExerciseName, description: "", stats: Stats.example, sets: [ExerciseSet(weight: 0, reps: 0)])
            routine.exercises.append(exercise)
            showAddExerciseSheet.toggle()
            newExerciseName = ""
        }
        
        func cancelCreation() {
            showAlert.toggle()
            alertTitle = "Confirm Cancellation"
            alertMessage = "All unsaved information will be lost"
            cancellationAlert = true
        }
        
        func checkInputs() {
            showAlert.toggle()
            alertTitle = "Invalid Information entered"
            alertMessage = "Routine name can't be blank"
        }
    }
}
