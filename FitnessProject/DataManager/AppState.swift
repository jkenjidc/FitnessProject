//
//  AppState.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/18/24.
//

import Foundation
import Firebase

@MainActor
class AppState: ObservableObject{
    @Published var user = User()
    @Published var isLoggedIn = false
    
    var hasHitRoutineLimit: Bool {
        return user.routines.count == 5
    }

    func addRoutine(routine: Routine) {
        user.routines.append(routine)

    }
    
    func deleteRoutine(at offsets: IndexSet){
        user.routines.remove(atOffsets: offsets)
    }
    
}
