//
//  EditRoutineScreen.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 11/27/25.
//

import SwiftUI

struct EditRoutineScreen: View {
    @State var routine: Routine
    @State var activeAlert: AlertType? = nil
    @Environment(Router.self) var router
    @State var alertService = AlertService()

    // Allow for no routine to be passed in for routine creation
    init(routine: Routine? = nil) {
        self._routine = State(initialValue: routine ?? Routine())
    }

    var body: some View {
        @Bindable var alertService = alertService
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
        .navigationTitle(routine.name)
        .navigationBarTitleDisplayMode(.inline)
        .scrollBounceBehavior(.basedOnSize)
        .navigationBarBackButtonHidden(true)
        .toolbar { Toolbar(routine: $routine) }
        .environment(self.alertService)
        .fitnessAlert(shouldPresent: $alertService.shouldPresent, alert: alertService.activeAlert)
    }
}

#Preview {
    EditRoutineScreen()
}
