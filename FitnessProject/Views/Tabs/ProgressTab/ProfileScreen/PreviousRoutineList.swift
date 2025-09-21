//
//  PreviousRoutineList.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/21/25.
//

import SwiftUI

struct PreviousRoutineList: View {
    let previousRoutines: [RoutineHistoryRecord]?
    var body: some View {
        VStack(alignment: .leading){
            Section {
                routineList
            } header: {
                Text("ROUTINE HISTORY")
                    .foregroundStyle(.secondary)
                    .bold()
                    .font(.headline)
            }
        }
    }

    @ViewBuilder
    var routineList: some View {
        if let previousRoutines = previousRoutines, !previousRoutines.isEmpty {
            List {
                ForEach(previousRoutines){ routine in
                    HStack{
                        Text(routine.nameOfRoutine)
                        Spacer()
                        Text("\(routine.dateDone.formatted(date: .numeric, time: .omitted))")
                    }
                }
            }
            .scrollBounceBehavior(.basedOnSize)
        } else {
            ContentUnavailableView(
                "No routines yet",
                systemImage: "figure.run.square.stack",
                description: Text("Complete routines to see your history here")
            )
        }
    }
}

#Preview {
    PreviousRoutineList(previousRoutines: [RoutineHistoryRecord.init(nameOfRoutine: "Test", durationOfRoutine: 56, exercises: [Exercise.example])])
}
