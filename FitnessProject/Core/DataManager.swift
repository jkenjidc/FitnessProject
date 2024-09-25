//
//  DataManager.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/25/24.
//

import Foundation
import FirebaseFirestore

final class DataManager {
    static let shared = DataManager()
    private init() {}
    func createNewUser(auth: AuthDataResultModel) async throws {
        var userData: [String:Any] = [
            "user_id": auth.uid,
            "is_anonymous" : auth.isAnonymous,
            "date_created" : Timestamp(),
            "email" : auth.email ?? ""
        ]
        
        if let photoUrl = auth.photoUrl {
            userData["photo_url"] = photoUrl
        }
        try await Firestore.firestore()
            .collection("users")
            .document(auth.uid)
            .setData(userData, merge: true)
    }
}
