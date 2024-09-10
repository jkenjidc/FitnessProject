//
//  User.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/10/24.
//

import Foundation


struct User: Identifiable, Hashable {
    var id = UUID().uuidString
    var name: String = ""
    var userName: String = ""
    var routines: [Routine] = []
    
}
