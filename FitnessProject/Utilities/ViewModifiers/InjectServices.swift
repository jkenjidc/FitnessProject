//
//  InjectServices.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 8/8/25.
//

import SwiftUI

extension View {
    func injectServices() -> some View {
        self.modifier(InjectServices())
    }
}

struct InjectServices: ViewModifier {
    @State var router = Router()
    @State var hkManager = HealthKitService()
    @State var exerciseService =  ExerciseService()
    @State var routineService = RoutineService()

    func body(content: Content) -> some View {
        content
            .environment(router)
            .environment(hkManager)
            .environment(exerciseService)
            .environment(routineService)
    }

}
