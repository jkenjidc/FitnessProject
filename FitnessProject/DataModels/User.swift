//
//  User.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/10/24.
//

import Foundation


struct CurrentUser: Identifiable, Hashable, Codable {
    var id: String = ""
    var name: String = ""
    var email: String = ""
    var userName: String = ""
    var isAnonymous: Bool = false
    var dateCreated: Date? = Date()
    var routines: [Routine] = []
    
    init(auth: AuthDataResultModel) {
        self.id = auth.uid
        self.isAnonymous  = auth.isAnonymous
        self.email = auth.email ?? ""
//        self.photoUrl = auth.photoUrl
        self.dateCreated =  Date()
    }
    
    init (auth: AuthDataResultModel, name: String) {
        self.id = auth.uid
        self.isAnonymous  = auth.isAnonymous
        self.email = auth.email ?? ""
        self.dateCreated =  Date()
        self.name = name
        
    }
    
    init() {}
}
