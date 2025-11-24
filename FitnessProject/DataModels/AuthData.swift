//
//  AuthDataResult.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/19/24.
//

import Foundation
import FirebaseAuth

struct AuthData: Equatable {
    let uid: String
    let name: String?
    let email: String?
    let photoUrl: String?
    let isAnonymous: Bool
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.photoUrl = user.photoURL?.absoluteString
        self.isAnonymous = user.isAnonymous
        self.name = user.displayName
    }
}
