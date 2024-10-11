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
        var selectedDays = Array(repeating: false, count: 7)
        let daysOfTheWeek = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
        var selectedDaysFooterText: String {
            if routine.daysToDo.count == 7 {
                return "Selected days: Everyday"
            } else if routine.daysToDo == ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]{
                return "Selected days: Weekdays"
            } else if routine.daysToDo == ["Saturday", "Sunday"]{
                return "Selected days: Weekends"
            } else if routine.daysToDo.count == 1 {
                return "Selected day: " + ListFormatter.localizedString(byJoining: routine.daysToDo)
            } else if routine.daysToDo.count > 1 {
                return "Selected days: " + ListFormatter.localizedString(byJoining: routine.daysToDo)
            } else {
                return ""
            }
        }
        
        init(routine: Routine? = nil) {
             if let unwrappedRoutine = routine {
                 self.routine = unwrappedRoutine
                 self.selectedDays = self.selectedDays.enumerated().map{index, element in
                     unwrappedRoutine.daysToDo.contains(daysOfTheWeek[index])
                 }
             }
         }
        
        var validInputs: Bool {
            return !routine.name.isEmpty
        }
        
        func saveExercise() {
            let exercise = Exercise(name: newExerciseName, sets: [ExerciseSet(weight: 0, reps: 0)])
            routine.exercises.append(exercise)
        }
        
        func cancelCreation() {
            showAlert.toggle()
            alertTitle = "Confirm Cancellation"
            alertMessage = "All unsaved information will be lost"
            cancellationAlert = true
        }
        
        func deleteExercise(index: IndexSet) {
            routine.exercises.remove(atOffsets: index)
        }
        
        func deleteExercise(exercise: Exercise) {
            routine.exercises.remove(at: routine.exercises.firstIndex(of: exercise) ?? 0)
        }
        
        func checkExerciseName() {
            isMissingExerciseName = newExerciseName.isEmpty
        }
        
        func selectDay(index: Int){
            if selectedDays[index] {
               selectedDays[index] = false
                routine.daysToDo.removeAll(where: {$0 == daysOfTheWeek[index]})
            } else {
                selectedDays[index] = true
                routine.daysToDo.append(daysOfTheWeek[index])
            }
            routine.daysToDo.sort(by: {daysOfTheWeek.firstIndex(of: $0) ?? 7 < daysOfTheWeek.firstIndex(of: $1) ?? 7})
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
