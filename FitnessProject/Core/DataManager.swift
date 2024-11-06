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
    private let rootStoragePath = "profileImages"
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
            let filename = getDocumentsDirectory().appendingPathComponent(FileNames.profileImage.rawValue)
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
    
    func loadRoutines() async throws{
        if let routines = user.routines {
            if !routines.isEmpty{
                let snapshot = try await routineCollection.whereField("id", in: routines).getDocuments()
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
        try await userDocument(userId: userId).getDocument(as: CurrentUser.self)
        
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
    func createUser(user: CurrentUser) async throws {
        try userDocument(userId: user.id).setData(from: user, merge: false)
        try await loadUser()
    }
    
    func createRoutine(routine: Routine) async throws {
        //Adds the routine to the apps's list of local routines
        routines.append(routine)
        
        //Add routine ID to routineIDs list of user
        if var routines = user.routines {
            routines.append(routine.id)
            user.routines = routines
        } else {
            user.routines = [routine.id]
        }
        
        //Sends the routine and user to the firestore DB
        try await updateRoutine(routine: routine)
        
    }
    
    func updateRoutine(routine: Routine) async throws {
        //save any changes to any existing instance of the same routine locally
        if let index = routines.firstIndex(where: {$0.id == routine.id}){
            routines[index] = routine
        }
        
        //save to DB and update the current user to fetch any data from user
        try routineDocument(routineId: routine.id).setData(from: routine, merge: true)
        try await updateCurrentUser()
    }
    
    //used for anonymous account linking
    func updateUser(user: CurrentUser) async throws {
        var linkingUser = user
        linkingUser.isAnonymous = false
        try userCollection.document(linkingUser.id).setData(from: linkingUser, merge: false)
        try await loadUser()
    }
    
    //used for updating current user 
    func updateCurrentUser(isLinking: Bool? = false, newName: String? = "") async throws {
        if let linkingAccount = isLinking {
            if linkingAccount {
                self.user.isAnonymous  = false
                self.user.name = newName ?? ""
            }

        }
        try userCollection.document(user.id).setData(from: self.user, merge: false)
        try await loadUser()
    }
    
    func uploadImage(image: UIImage) async throws {
        //path of image in firebase storage
        let path = "\(rootStoragePath)/\(user.id)/profileImage.jpeg"
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
        if let routines = user.routines {
            for routine in routines {
                try await routineCollection.document(routine).delete()
            }
        }
        self.user = CurrentUser()
        self.routines = [Routine]()
    }
    
    func deleteRoutine(at index: IndexSet) async throws {
        let beforeRemoval = Set(routines)
        routines.remove(atOffsets: index)
        let afterRemoval = Set(routines)
        let removedItem = beforeRemoval.symmetricDifference(afterRemoval)
        if let routineToDelete = removedItem.first, var routines = user.routines {
            routines.removeAll(where: { $0 == routineToDelete.id })
            user.routines = routines
            try await routineCollection.document("\(routineToDelete.id)").delete()
            try await updateCurrentUser()
        }
    }
}
