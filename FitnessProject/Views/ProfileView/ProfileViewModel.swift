//
//  ProfileViewModel.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/24/24.
//

import Foundation

extension ProfileView {
    
    
    @MainActor
    @Observable
    class ViewModel {
        private(set) var user: AuthDataResultModel? = nil
        func loadCurrentUser() throws {
            self.user =  try  AuthManager.shared.getAuthenticatedUser()
        }
    }
}
