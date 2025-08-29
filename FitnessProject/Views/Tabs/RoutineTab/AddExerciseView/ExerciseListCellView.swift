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
                .keyboardType(.decimalPad)
            TextField("\(exerciseSet.reps)", value: $exerciseSet.reps, format: .number)
                .multilineTextAlignment(.center)
                .keyboardType(.numberPad)
            if timerMode {
                Image(systemName: ( completed ? "checkmark.square.fill" : "square"))
                    .foregroundStyle(.green)
                    .onTapGesture {
                        if let lastBestAttempt = exercise.lastBestSet {
                            if exerciseSet.totalLoad > lastBestAttempt.totalLoad{
                                exercise.lastBestSet = exerciseSet
                                exercise.lastBestSet?.lastBestAttempt = Date.now
                            }
                        } else {
                            exercise.lastBestSet = exerciseSet
                            exercise.lastBestSet?.lastBestAttempt = Date.now
                        }
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
    var weightUnit: String {
        return "\(dataManager.user.preferences.usingImperialWeightUnits ? "lbs" : "kg")"
    }

    var lastBestSetText: String? {
        if let lastBestSet = exercise.lastBestSet, let dateForSet = exercise.lastBestSet?.lastBestAttempt {
            return "best set \(dateDescription(for: dateForSet) ?? ""): \(lastBestSet.formattedWeight) \(weightUnit) x \(lastBestSet.reps)"
        } else {
            return nil
        }
    }
    var deleteExercise: (Exercise) -> Void
    let columns = [
        GridItem(.flexible(minimum: 40, maximum: 50)),    // minus button
        GridItem(.flexible(minimum: 40, maximum: 60)),    // set number
        GridItem(.flexible(minimum: 60, maximum: 100)),   // weight
        GridItem(.flexible(minimum: 60, maximum: 100)),   // reps
        GridItem(.flexible(minimum: 40, maximum: 50))     // checkmark/empty space
    ]

    var body: some View {
        VStack(alignment: .center, spacing: 0){
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

            LazyVGrid(columns: columns, spacing: 10) {
                Text("")
                Text("Sets")
                    .frame(maxWidth: .infinity)
                Text(weightUnit)
                    .frame(maxWidth: .infinity)
                Text("Reps")
                    .frame(maxWidth: .infinity)
                Text("")
                ForEach($exercise.sets){ exerciseSet in
                    exerciseSetListRowView(exercise: $exercise, exerciseSet: exerciseSet, timerMode: timerMode)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 15)
            if let bestAttemptString = lastBestSetText {
                HStack{
                    Spacer()
                    Text(bestAttemptString)
                        .foregroundStyle(.secondary.opacity(0.7))
                        .padding(.bottom)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            }

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
        .containerRelativeFrame(.horizontal)
        .padding(.bottom, 5)
    }

    func addSet() {
        let lastWeight = exercise.sets.last?.weight ?? 0
        let lastRep = exercise.sets.last?.reps ?? 0
        exercise.sets.append(ExerciseSet(weight: lastWeight, reps: lastRep))
    }

    func dateDescription(for date: Date) -> String? {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.day, .month], from: date, to: now)

        guard let days = components.day, let _ = components.month else {
            return nil
        }

        switch days {
        case 0:
            return "today"
        case 1:
            return "yesterday"
        case let x where x % 30 == 0 && x >= 60:
            let monthCount = x / 30
            return "\(monthCount) months ago"
        default:
            return "\(days) days ago"
        }
    }
}

#Preview {
    var exercise = Exercise(name: "Exercise 1", sets: [ExerciseSet(weight: 0, reps: 0)])
    func dummyfunc(exerise: Exercise){}
    return ExerciseListCellView(exercise: .constant(exercise), screenMode: .creation, deleteExercise: dummyfunc.self)
        .preferredColorScheme(.dark)
}
