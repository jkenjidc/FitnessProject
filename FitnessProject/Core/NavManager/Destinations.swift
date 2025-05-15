//
//  Destinations.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 10/4/24.
//

import Foundation

enum Destination: Codable, Hashable {
    case signInScreen
    case signUpScreen
    case mainNavigationScreen
    case welcomeScreen
    case createRoutineScreen(routine: Routine?, screenMode: ScreenMode?)
    case settingsScreen
    case updatePasswordScreen
    case timerScreen(routine: Routine)
}
