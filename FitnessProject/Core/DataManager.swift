//
//  DataManager.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/25/24.
//

import Foundation
import FirebaseFirestore
import Firebase
import FirebaseStorage

public enum FileNames: String {
    case profileImage = "profileImage.jpeg"
}

extension Array {
    mutating func mutatingForEach(_ body: (inout Element) throws -> Void) rethrows {
        for index in indices {
            try body(&self[index])
        }
    }
}

@Observable
final class DataManager {
    var user = CurrentUser()
    var routines = [Routine]()
    private let userCollection = Firestore.firestore().collection("users")
    private let routineCollection = Firestore.firestore().collection("routines")
    private let storageRef = Storage.storage().reference()
    private let rootStoragePath = "profile_images"
    static let shared = DataManager()
    private init() {}
    
    // MARK: DB HELPERS
    private let encoder: Firestore.Encoder = {
        let encoder = Firestore.Encoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()
    
    private let decoder: Firestore.Decoder = {
        let decoder = Firestore.Decoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
    func routineDocument(routineId: String) -> DocumentReference {
        routineCollection.document(routineId)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func cacheImage(from inputImage: UIImage) throws {
        if let data = inputImage.jpegData(compressionQuality: 0.8) {
            let filename = DataManager.shared.getDocumentsDirectory().appendingPathComponent(FileNames.profileImage.rawValue)
            try data.write(to: filename)
            
        }
    }
    
    // MARK: Loading users
    func loadUser() async throws {
        user = try await getUser(userId: AuthManager.shared.authProfile?.uid ?? "")
        if let profileImageUrl = user.profileImageUrl {
            try await getProfileImage(path: profileImageUrl)
        }
    }
    
//    func loadRoutines() async throws {
//        if let routineIDs = user.routineIDs {
//            routineIDs.forEach { routineID in
//                Task{
//                    self.routines.append(try await getRoutine(routineID: routineID))
//                }
//            }
//        }
//        print(routines)
//    }
    func loadRoutines() async throws{
        if let routineIDs = user.routineIDs {
            if !routineIDs.isEmpty{
                let snapshot = try await routineCollection.whereField("id", in: routineIDs).getDocuments()
                var tempRoutines = [Routine]()
                for document in snapshot.documents {
                    let routine = try document.data(as: Routine.self)
                    tempRoutines.append(routine)
                }
                self.routines = tempRoutines
            }
        }
    }
    
    func getUser(userId: String) async throws -> CurrentUser {
        try await userDocument(userId: userId).getDocument(as: CurrentUser.self, decoder: decoder)
        
    }
    
    func getRoutine(routineID: String) async throws -> Routine {
        try await routineDocument(routineId: routineID).getDocument(as: Routine.self, decoder: decoder)
        
    }
    
    func getProfileImage(path: String) async throws{
        let filename = self.getDocumentsDirectory().appendingPathComponent(FileNames.profileImage.rawValue)
        if !FileManager.default.fileExists(atPath: filename.path()){
            let profileImageRef = storageRef.child(path)
            profileImageRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                if data != nil && error == nil {
                    try? data?.write(to: filename)
                }
            }
        }
    }
    
    // MARK: Data creation and updating
    func createNewUser(user: CurrentUser) async throws {
        try userDocument(userId: user.id).setData(from: user, merge: false, encoder: encoder)
        try await loadUser()
    }
    
    func createNewRoutine(routine: Routine) async throws {
        //Adds the routine to the apps's list of current routines or updates an existing one
        if !routines.contains(routine){
            routines.append(routine)
        } else {
            if let index = routines.firstIndex(where: {$0.id == routine.id}){
                routines[index] = routine
            }
        }
        //Add routine ID to routineIDs list of user
        if var routineId = user.routineIDs {
            if !routineId.contains(routine.id){
                routineId.append(routine.id)
                user.routineIDs = routineId
            }
        } else {
            user.routineIDs = [routine.id]
        }
        
        try routineDocument(routineId: routine.id).setData(from: routine, merge: true)
        try await updateCurrentUser()
        
    }
    
    func updateRoutine(routine: Routine) async throws {
        if let index = routines.firstIndex(where: {$0.id == routine.id}){
            routines[index] = routine
        }
        try routineDocument(routineId: routine.id).setData(from: routine, merge: true)
        try await updateCurrentUser()
    }
    
    //need to just add routine ID
    func addRoutine(routine: Routine) async throws {
        if !user.routines.contains(routine){
            user.routines.append(routine)
        } else {
            if let index = user.routines.firstIndex(where: {$0.id == routine.id}){
                user.routines[index] = routine
            }
        }
        try userDocument(userId: user.id).setData(from: user, merge: true, encoder: encoder)
        try await self.loadUser()
    }
    
    //used for anonymous account linking
    func updateUser(user: CurrentUser) async throws {
        try userCollection.document(user.id).setData(from: user, merge: false, encoder: encoder)
        try await loadUser()
    }
    
    //used for updating current user 
    func updateCurrentUser() async throws {
        try userCollection.document(user.id).setData(from: user, merge: false, encoder: encoder)
        try await loadUser()
    }
    
    func uploadImage(image: UIImage) async throws {
        //path of image in firebase storage
        let path = "\(rootStoragePath)/\(user.id)/profile_image.jpeg"
        let profileImageRef = storageRef.child(path)
        let imageData = image.jpegData(compressionQuality: 0.8)
        if let unwrappedImageData = imageData {
            _ = profileImageRef.putData(unwrappedImageData, metadata: nil){ metadata, error in
                if error == nil && metadata != nil {
                    //if upload is succesfull save path URL to user to have access for later
                    self.user.profileImageUrl = path
                    Task{
                        try await self.updateCurrentUser()
                    }
                    
                } else {
                    print(error?.localizedDescription ?? "")
                }
            }
        }
        
    }
    func switchWeightUnits() async throws {
        let switchValue = user.preferences.usingImperialWeightUnits ? 1/2.2 : 2.2
        routines.mutatingForEach { routine in
            routine.exercises.mutatingForEach { exercise in
                exercise.sets.mutatingForEach { exerciseSet in
                    exerciseSet.weight = exerciseSet.weight * switchValue
                }
            }
        }
        try await updateCurrentUser()
        
    }
    
    // MARK: Data deletions
    func deleteUser() async throws {
        try await userCollection.document(user.id).delete()
        self.user = CurrentUser()
    }
    
//    func deleteRoutine(at index: IndexSet) async throws {
//        user.routines.remove(atOffsets: index)
//        let encodedRoutines = try user.routines.map { try encoder.encode($0)}
//        
//        try await userCollection.document(user.id).updateData(["routines": encodedRoutines])
//    }
    
    func deleteRoutine(at index: IndexSet) async throws {
        let beforeRemoval = Set(routines)
        routines.remove(atOffsets: index)
        let afterRemoval = Set(routines)
        let removedItem = beforeRemoval.symmetricDifference(afterRemoval)
        if let routineToDelete = removedItem.first, var routineIDs = user.routineIDs {
            routineIDs.removeAll(where: { $0 == routineToDelete.id })
            user.routineIDs = routineIDs
            try await routineCollection.document("\(routineToDelete.id)").delete()
            try await updateCurrentUser()
            try await loadRoutines()
        }
    }
}
