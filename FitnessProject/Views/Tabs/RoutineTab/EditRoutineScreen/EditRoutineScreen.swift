//
//  EditRoutineScreen.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 11/27/25.
//

import SwiftUI

struct EditRoutineScreen: View {
    @State var routine: Routine
    @Environment(Router.self) var router

    // Allow for no routine to be passed in for routine creation
    init(routine: Routine? = nil) {
        self._routine = State(initialValue: routine ?? Routine())
    }

    var body: some View {
        Form {
            NameSection(name: $routine.name)
            DayPickerSection(selectedDays: $routine.daysToDo)
            DescriptionSection(description: $routine.description)
            Button("Add Exercise") {
                //TODO: Handle routing
//                router.presentSheet(.addExerciseSheetV2)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    EditRoutineScreen()
}
