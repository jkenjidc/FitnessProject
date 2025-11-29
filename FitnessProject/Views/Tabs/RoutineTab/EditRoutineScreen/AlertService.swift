//
//  AlertService.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 11/28/25.
//

import Foundation
import Observation

@Observable class AlertService {
    var activeAlert: ActiveAlert?
    // For alert presentation since alert(item:) is deprecated
    var shouldPresent: Bool = false {
        didSet {
            // Clear out active alert when alert is dismissed
            activeAlert = (!shouldPresent ? nil : activeAlert)
        }
    }

    func presentAlert(_ alert: ActiveAlert) {
        activeAlert = alert
        shouldPresent = true
    }
}
