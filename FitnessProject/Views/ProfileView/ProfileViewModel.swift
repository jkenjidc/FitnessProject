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
        private(set) var user: CurrentUser? = nil
        
        func loadCurrentUser() async throws {
            self.user = try await DataManager.shared.getUser(userId: AuthManager.shared.authProfile?.uid ?? "")
        }
        
//        @MainActor
//        func togglePremiumStatus() {
//            guard let user else { return }
//            let currentValue =  user.isPremium ?? false
//            Task{
//                try await DataManager.shared.updateUserPremiumStatus(userId: user.userId, isPremium: !currentValue)
//                self.user = try await DataManager.shared.getUser(userId: user.userId)
//            }
//        }
    }
}
