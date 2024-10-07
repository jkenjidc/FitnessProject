//
//  CreateRoutineViewModel.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/11/24.
//

import Foundation

extension CreateRoutineView {
    @Observable class ViewModel {
        var routine: Routine = Routine()
        var newExerciseName = ""
        var showAlert = false
        var alertMessage = ""
        var alertTitle = ""
        var cancellationAlert = false
        var isMissingRoutineName: Bool = false
        var isMissingExerciseName: Bool = false
        
        init(routine: Routine? = nil) {
             if let unwroutine = routine {
                 self.routine = unwroutine
             } else {
                 self.routine.name = ""
             }
         }
        
        var validInputs: Bool {
            return !routine.name.isEmpty
        }
        
        func saveExercise() {
            let exercise = Exercise(name: newExerciseName, description: "", stats: Stats.example, sets: [ExerciseSet(weight: 0, reps: 0)])
            routine.exercises.append(exercise)
            newExerciseName = ""
        }
        
        func cancelCreation() {
            showAlert.toggle()
            alertTitle = "Confirm Cancellation"
            alertMessage = "All unsaved information will be lost"
            cancellationAlert = true
        }
        
        func checkExerciseName() {
            isMissingExerciseName = newExerciseName.isEmpty
        }
        
        func checkRoutineName() {
            isMissingRoutineName = (routine.name.isEmpty && !cancellationAlert)
        }
        
        func saveRoutine() async {
            do {
                try await DataManager.shared.addRoutine(routine: routine)
            } catch {
                print("error")
            }
        }
    }
}
