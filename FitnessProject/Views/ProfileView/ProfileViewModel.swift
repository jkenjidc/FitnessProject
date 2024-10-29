//
//  ProfileViewModel.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/24/24.
//

import Foundation

extension ProfileView {
    @Observable
    class ViewModel {
        var confirmAccountDeletion = false
        
        func signOut(pop: () -> Void) {
            do {
                try AuthManager.shared.signOut()
                pop()
            } catch {
                print(error.localizedDescription)
            }
        }
        
        func deleteAccount(pop: () -> Void) async {
            do {
                try await DataManager.shared.deleteUser()
                try await AuthManager.shared.deleteAccount()
                pop()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
