//
//  Sheets.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 10/4/24.
//

import Foundation
import SwiftUI

enum Sheet: Identifiable {
    case addExerciseSheetV2(Binding<[ExerciseEntry]>)
    case forgotPassswordSheet
    case streakInfo
    case exerciseDetail(ExerciseV2)

    public var id: Int {
        switch self {
        case .forgotPassswordSheet: return 1
        case .streakInfo: return 2
        case .exerciseDetail: return 3
        case  .addExerciseSheetV2: return 4
        }
    }
}
