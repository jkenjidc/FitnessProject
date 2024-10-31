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
        
        func loadImageFromDirectory() {
            //loads profile picture from local cache directory
            if profileImage == nil {
                let path = getDocumentsDirectory().appending(path: "profileImage.jpeg")
                if FileManager.default.fileExists(atPath: path.path()){
                    print("file exists")
                } else {
                    print("file doesnt exist")
                }
                if let UIImage = UIImage(contentsOfFile: path.path()){
                    profileImage = Image(uiImage: UIImage)
                } else {
                    print("error loading image")
                }
            }
        }
        
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
        
        func getDocumentsDirectory() -> URL {
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let documentsDirectory = paths[0]
            return documentsDirectory
        }
        
        func loadImage() {
            Task {
                //loads selected image into the profileImage view
                if let loaded = try? await selectedItem?.loadTransferable(type: Image.self){
                    profileImage = loaded
                } else {
                    print("Error")
                }
                
                if let loadedData = try? await selectedItem?.loadTransferable(type: Data.self){
                    //uploads profile image to firebase storage
                    guard let inputImage = UIImage(data: loadedData) else { return }
                    try await DataManager.shared.uploadImage(image: inputImage)
                    
                    //saves UIImage jpeg data for local caching
                    if let data = inputImage.jpegData(compressionQuality: 0.8) {
                        let filename = getDocumentsDirectory().appendingPathComponent("profileImage.jpeg")
                        do{
                            try data.write(to: filename)
                            print("successfully saved at \(filename)")
                        } catch {
                            print("error saving image")
                        }
                    }
                }else {
                    print("error")
                }
            }
        }
        
        func uploadPhoto() {
            
        }
    }
}
