//
//  Sheets.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 10/4/24.
//

import Foundation
import SwiftUI

enum Sheet: Identifiable {
    case addExerciseSheet(viewModel: Binding<CreateRoutineScreen.ViewModel>)
    case addExerciseSheetV2(Binding<[Exercise]>)
    case forgotPassswordSheet
    case streakInfo
    case exerciseDetail(ExerciseV2)

    public var id: Int {
        switch self {
        case .addExerciseSheet: return 0
        case .forgotPassswordSheet: return 1
        case .streakInfo: return 2
        case .exerciseDetail: return 3
        case  .addExerciseSheetV2: return 4
        }
    }
}
