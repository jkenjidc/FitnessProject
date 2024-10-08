//
//  FullScreenCovers.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 10/4/24.
//

import Foundation

enum FullScreenCover: Identifiable {
    var id: Int {
        switch self {
        case .welcomeView: return 0
        }
    }
    
    case welcomeView
}
