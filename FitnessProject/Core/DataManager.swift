//
//  DataManager.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/25/24.
//

import Foundation
import FirebaseFirestore

struct DBUser: Codable {
    let userId: String
    let isAnonymous: Bool?
    let email: String?
    let photoUrl: String?
    let dateCreated: Date?
    let isPremium: Bool?
    
    init(auth: AuthDataResultModel) {
        self.userId = auth.uid
        self.isAnonymous  = auth.isAnonymous
        self.email = auth.email
        self.photoUrl = auth.photoUrl
        self.dateCreated =  Date()
        self.isPremium = false
    }
    
    init(
        userId: String,
        isAnonymous: Bool? = nil,
        email: String? = nil,
        photoUrl: String? = nil,
        dateCreated: Date? = nil,
        isPremium: Bool? = nil
    ){
        self.userId = userId
        self.isAnonymous  = isAnonymous
        self.email = email
        self.photoUrl = photoUrl
        self.dateCreated =  dateCreated
        self.isPremium = isPremium
    }
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case isAnonymous = "is_anonymous"
        case email = "email"
        case photoUrl = "photo_url"
        case dateCreated = "date_created"
        case isPremium = "is_premium"
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userId, forKey: .userId)
        try container.encodeIfPresent(self.isAnonymous, forKey: .isAnonymous)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.photoUrl, forKey: .photoUrl)
        try container.encodeIfPresent(self.dateCreated, forKey: .dateCreated)
        try container.encodeIfPresent(self.isPremium, forKey: .isPremium)
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.isAnonymous = try container.decodeIfPresent(Bool.self, forKey: .isAnonymous)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.photoUrl = try container.decodeIfPresent(String.self, forKey: .photoUrl)
        self.dateCreated = try container.decodeIfPresent(Date.self, forKey: .dateCreated)
        self.isPremium = try container.decodeIfPresent(Bool.self, forKey: .isPremium)
    }
        
}
@MainActor
@Observable
final class DataManager {
    private let userCollection = Firestore.firestore()
        .collection("users")
    static let shared = DataManager()
    private init() {}
    func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
    
    func createNewUser(user: DBUser) async throws {
        try  userDocument(userId: user.userId).setData(from: user,merge: false)
    }
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
        
        try await userDocument(userId: auth.uid).setData(userData, merge: true)
        
        
    }
    
    func getUser(userId: String) async throws -> DBUser {
        try await userDocument(userId: userId).getDocument(as: DBUser.self)
        
    }
    
    func updateUserPremiumStatus(user: DBUser) async throws {
        try  userDocument(userId: user.userId).setData(from: user, merge: true)
    }
    
    func updateUserPremiumStatus(userId: String, isPremium: Bool) async throws {
        var data: [String:Any] = [
            DBUser.CodingKeys.isPremium.rawValue : isPremium
        ]
        try  await userDocument(userId: userId).updateData(data)
    }
    //    func getUser(userId: String ) async throws -> DBUser {
    //        let snapshot = try await userDocument(userId: userId).getDocument()
    //
    //        guard let data = snapshot.data(), let userId = data["user_id"] as? String else {
    //            throw URLError(.badServerResponse)
    //        }
    //
    //
    //        let isAnonymous = data ["is_anonymous"] as? Bool
    //        let email =  data["email"] as? String
    //        let photoUrl =  data["photo_url"] as? String
    //        let dataCreated = data["date_created"] as? Date
    //
    //        return DBUser(userId: userId, isAnonymous: isAnonymous, email: email, photoUrl: photoUrl, dataCreated: dataCreated)
    //
    //    }
}
