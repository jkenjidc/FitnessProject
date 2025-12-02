//
//  ToolbarContent.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 11/28/25.
//

import Foundation
import SwiftUI

extension EditRoutineScreen {
    struct Toolbar: ToolbarContent {
        @Environment(Router.self) var router
        @Environment(AppCoordinator.self) var appCoordinator
        @Environment(AlertService.self) var alertService
        @Binding var routine: Routine
        var body: some ToolbarContent {
            ToolbarItem(placement: .topBarLeading) {
                Button(role: .destructive) {
                    alertService.presentAlert(cancelAlert)
                } label: {
                    Text("Exit")
                }
                .tint(.red)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    router.pop()
                    Task {
                        //TODO: handle error state
                        try? await appCoordinator.updateRoutine(routine)
                    }
                } label: {
                    Text("Save")
                }
            }
        }

        var cancelAlert: ActiveAlert {
            .init(
                title: "Confirm Exit",
                message: "All unsaved information will be lost",
                primaryButtonTitle: "Exit",
                primaryButtonAction: { router.pop() },
                primaryButtonRole: .destructive
            )
        }
    }
}
