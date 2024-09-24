//
//  AppState.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/18/24.
//

import Foundation
import FirebaseAuth
import SwiftUI
import Firebase
import FirebaseFirestore

@MainActor
@Observable 
class AppState{
    var user = CurrentUser()
    var router = Router()
//    var db: Any? = nil
    
//    func loadDb() {
//        db  = Firestore.firestore()
//    }
    
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
