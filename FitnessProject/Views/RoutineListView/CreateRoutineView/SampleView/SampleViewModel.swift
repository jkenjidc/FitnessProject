//
//  SampleViewModel.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 10/4/24.
//

import Foundation

extension SampleView {
    @Observable class ViewModel {
        var routine: Routine?
        init(routine: Routine? = nil) {
             if let unwroutine = routine {
                 self.routine = unwroutine
             } else {
                 self.routine = Routine()
                 self.routine!.name = "Empty Routine"
             }
         }
    }
}
