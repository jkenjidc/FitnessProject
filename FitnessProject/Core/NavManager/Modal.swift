//
//  Modal.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 7/7/25.
//

import Foundation

enum Modal: Identifiable {
    var id: Int {
        switch self {
        case .weightChartEntry: return 0
        case .routineInfo: return 1
        }
    }

    case weightChartEntry
    case routineInfo(routine: Routine)
}
