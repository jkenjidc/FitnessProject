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
        
        func loadImageFromPicker() {
            Task {
                if let loadedData = try? await selectedItem?.loadTransferable(type: Data.self){
                    guard let inputImage = UIImage(data: loadedData) else { return }
                    profileImage = Image(uiImage: inputImage)
                    await uploadAndCacheProfileImage(image: inputImage)
                }
            }
        }
        
        func loadImageFromDirectory() {
            //loads profile picture from local cache directory
            if profileImage == nil {
                let fileName = DataManager.shared.getDocumentsDirectory().appending(path: FileNames.profileImage.rawValue)
                if let UIImage = UIImage(contentsOfFile: fileName.path()){
                    profileImage = Image(uiImage: UIImage)
                }
            }
        }
        
        func uploadAndCacheProfileImage(image: UIImage) async {
            do {
                try await DataManager.shared.uploadImage(image: image)
                try DataManager.shared.cacheImage(from: image)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
