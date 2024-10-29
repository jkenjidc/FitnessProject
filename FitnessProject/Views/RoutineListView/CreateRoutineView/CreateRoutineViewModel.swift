//
//  CreateRoutineViewModel.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/11/24.
//

import Foundation

public enum AlertType {
    case cancelCreation
    case exerciseDeletion
    case routineCompletion
}

extension CreateRoutineView {
    @Observable class ViewModel {
        
        //MARK: BEHAVIOR MODE
        var currentScreenMode = ScreenMode.creation
        var currentAlertType: AlertType = .cancelCreation

        //MARK: INPUTS
        var routine: Routine = Routine()
        var currentExercise: Exercise?
        var newExerciseName = ""
        
        //MARK: ALERT
        var showAlert = false
        var alertMessage = ""
        var alertTitle = ""
        
        //MARK: VALIDATION
        var isMissingRoutineName = false
        var isMissingExerciseName = false
        var validInputs: Bool {
            return !routine.name.isEmpty
        }
        
        //MARK: DAYS PICKER
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
        
        //MARK: TIMER
        var elapsedTime: TimeInterval = 0
        let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        var isTimerActive = true
        var timeString: String {
            let minutes = Int(elapsedTime) / 60
            let seconds = Int(elapsedTime) % 60
            let hour = Int(minutes) / 60
            return String(format: "%02d.%02d.%02d", hour, minutes, seconds)
        }
        var timerMode: Bool {
            return currentScreenMode == .timer
        }
        
        init(routine: Routine? = nil, screenMode: ScreenMode? = .creation) {
             if let unwrappedRoutine = routine {
                 self.routine = unwrappedRoutine
                 self.selectedDays = self.selectedDays.enumerated().map{index, element in
                     unwrappedRoutine.daysToDo.contains(daysOfTheWeek[index])
                 }
                 self.currentScreenMode = screenMode ?? .creation
                 isTimerActive = timerMode
             }
            
            
         }
        
        //MARK: DATA MANIPULATION
        func saveExercise() {
            let exercise = Exercise(name: newExerciseName, sets: [ExerciseSet(weight: 0, reps: 0)])
            routine.exercises.append(exercise)
        }
        
        func saveRoutineHistory() async {
            isTimerActive = false
            do {
                try await DataManager.shared.addRoutine(routine: routine)
            } catch {
                print(error.localizedDescription)
            }
        }
        
        func finishRoutine() {
            let historyRecord = RoutineHistoryRecord(nameOfRoutine: routine.name, durationOfRoutine: Int(elapsedTime), exercises: routine.exercises)
            if var routineHistory = DataManager.shared.user.routineHistory {
                routineHistory.insert(historyRecord, at: 0)
                DataManager.shared.user.routineHistory = routineHistory
            }
            Task {
                await saveRoutineHistory()
            }
        }
        
        func deleteExercise(index: IndexSet) {
            routine.exercises.remove(atOffsets: index)
        }
        
        func deleteExercise(exercise: Exercise) {
            routine.exercises.remove(at: routine.exercises.firstIndex(of: exercise) ?? 0)
        }
        
        func trailingTabBarItemAction(action: ()-> Void) {
            switch currentScreenMode {
            case .creation, .editing:
                if validInputs {
                    Task {
                        await saveRoutineHistory()
                    }
                    action()
                } else {
                    checkRoutineName()
                }
            case .timer:
                confirmFinishExercise()
            }
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

        //MARK: ALERT CONFIRMATIONS
        func confirmCancelCreation() {
            showAlert.toggle()
            alertTitle = "Confirm Cancellation"
            alertMessage = "All unsaved information will be lost"
            currentAlertType = .cancelCreation
        }
        
        func confirmDeleteExerise(exercise: Exercise) {
            alertTitle = "Delete Exercise"
            alertMessage = "Are you sure you want to permanently remove this exercise?"
            currentExercise = exercise
            currentAlertType = .exerciseDeletion
            showAlert.toggle()
        }
        
        func confirmFinishExercise() {
            alertTitle = "Finish Routine"
            alertMessage = "Complete routine and save progress?"
            currentAlertType = .routineCompletion
            showAlert.toggle()
        }
        
        //MARK: INPUT VALIDATION
        func checkExerciseName() {
            isMissingExerciseName = newExerciseName.isEmpty
        }
        
        func checkRoutineName() {
            isMissingRoutineName = routine.name.isEmpty
        }
    }
}
