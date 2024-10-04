//
//  FullScreenCovers.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 10/4/24.
//

import Foundation

enum FullScreenCover: String, Identifiable {
    var id: String {
        self.rawValue
    }
    
    case welcomeView
}
