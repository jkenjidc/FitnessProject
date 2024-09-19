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

@MainActor

@Observable 
class AppState{
    var user = CurrentUser()
    var router = Router()
    var isLoggedIn = false
    let shared =  AuthManager.shared
    var authState = AuthState.loggedOut
    
    public enum AuthState{
        case loggedOut
        case guestMode
        case loggedIn
    }
    
    init() {
        FirebaseApp.configure()
        Auth.auth().addStateDidChangeListener { _, user in
            switch user {
            case nil:
                self.authState = .loggedOut
            default:
                self.authState = .loggedIn
            }
        }
    }
    
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
