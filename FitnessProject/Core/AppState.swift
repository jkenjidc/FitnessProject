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
    var isAnonymous = false
    let shared =  AuthManager.shared
    var authState = AuthState.loggedOut
    var showsignInView = false
    var signInBinding: Binding<Bool> {
        Binding(
                    get: { self.showsignInView },
                    set: { self.showsignInView = $0 }
                )
    }
    
    public enum AuthState{
        case loggedOut
        case guestMode
        case loggedIn
    }
    
    init() {
        FirebaseApp.configure()
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
    
    func checkAuth() {
        let authUser = try? shared.getAuthenticatedUser()
        showsignInView = authUser == nil
    }
    
    func signUp(email: String, password: String) async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found.")
            return
        }
        do {
            try await shared.createUser(email: email, password: password)
            showsignInView = false
        } catch {
            print(error)
        }

    }
    
    func signIn(email: String, password: String) async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found.")
            return
        }
        do {
            try await shared.signInUser(email: email, password: password)
            showsignInView = false
        } catch {
            print(error)
        }

    }
    
    func resetPassword(email: String) async throws {
        guard !email.isEmpty else { return }
        do {
            try await shared.resetPassword(email: email)
        } catch {
            print(error)
        }
    }
    
    func updatePassword(password: String) async throws {
        guard !password.isEmpty else { return }
        do{
            try await shared.updatePassword(password: password)
        } catch {
            print(error)
        }
    }
    
    func signInAnonymous() async throws {
        do {
            try await shared.signInAnonymously()
            showsignInView = false
            isAnonymous = true
        } catch {
            print(error)
        }
    }
    
    func isUserAnonymous() -> Bool {
        let authUser = try? shared.getAuthenticatedUser()
        return authUser?.isAnonymous ?? false
    }
    
    func linkEmail(email: String, password: String) async throws {
        guard !password.isEmpty else { return }
        do {
            try await shared.linkEmail(email: email, password: password)
            isAnonymous = false
        } catch {
            print(error)
        }
    }
    
}
