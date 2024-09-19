//
//  Router.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/18/24.
//

import Foundation
import SwiftUI

@Observable
class Router {
    public enum Destination: Codable, Hashable {
        case signInScreen
        case mainNavigationScreen
    }
    
    var navPath = NavigationPath()
    func navigate(to destination: Destination) {
        navPath.append(destination)
    }
    
    func navigateBack() {
        navPath.removeLast()
    }
    
    func navigateToRoot() {
        navPath.removeLast(navPath.count)
    }
}
