//
//  TimerHeaderViewModel.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 8/29/25.
//

import Foundation
import SwiftUI

extension TimerScreen.TimerHeader {
    @Observable class ViewModel {
        var elapsedTime: TimeInterval = 0
        var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        var isPaused: Bool = false
        var routineName: String = ""

        var timeString: String {
            let minutes = Int(elapsedTime) / 60
            let seconds = Int(elapsedTime) % 60
            let hour = Int(minutes) / 60
            return String(format: "%02d.%02d.%02d", hour, minutes, seconds)
        }

        var buttonColor: Color {
            isPaused ? .blue : .gray
        }

        var backgroundColor: Color {
            isPaused ? .gray : .blue
        }

        var buttonIconName: String {
            isPaused ? "play.circle.fill" :"pause.circle.fill"
        }

        init(routineName: String) {
            self.routineName = routineName
        }

        init(){}
    }
}
