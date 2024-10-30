//
//  ProfileViewModel.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/24/24.
//

import Foundation
import SwiftUI
import PhotosUI
import CoreImage

extension ProfileView {
    @Observable
    class ViewModel {
        var confirmAccountDeletion = false
        var selectedItem: PhotosPickerItem?
        var profileImage: Image?
        
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
        
        func loadImage() {
            Task {
                if let loaded = try? await selectedItem?.loadTransferable(type: Image.self){
                    profileImage = loaded
                } else {
                    print("Error")
                }
            }
        }
    }
}
