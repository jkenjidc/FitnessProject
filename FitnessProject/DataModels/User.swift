//
//  User.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/10/24.
//

import Foundation


struct CurrentUser: Identifiable, Hashable {
    var id: String = ""
    var name: String = ""
    var userName: String = ""
    var routines: [Routine] = []
    
}
