//
//  ProfileViewModel.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/24/24.
//

import Foundation

@MainActor
extension ProfileView {
    @Observable
    class ViewModel {
        private(set) var user: DBUser? = nil
        
        func loadCurrentUser() async throws {
            self.user = try await DataManager.shared.getUser(userId: AuthManager.shared.authProfile?.uid ?? "")
        }
    }
}
