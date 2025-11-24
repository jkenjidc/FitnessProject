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
    var routines: [String]? = []
    var preferences: Preferences = Preferences()
    var routineHistory: [RoutineHistoryRecord]? = []
    var profileImageUrl: String? = ""
    var weightHistory: [WeightEntry]? = []
    var streakInfo: StreakInfo? = nil


    init(auth: AuthData) {
        self.id = auth.uid
        self.name = auth.name ?? ""
        self.isAnonymous  = auth.isAnonymous
        self.email = auth.email ?? ""
        self.dateCreated =  Date()
        self.routineHistory = []
        self.profileImageUrl = ""
        self.routines = []
        self.streakInfo = StreakInfo()
    }
    
    init (auth: AuthData, name: String) {
        self.id = auth.uid
        self.isAnonymous  = auth.isAnonymous
        self.email = auth.email ?? ""
        self.dateCreated =  Date()
        self.name = name
        self.routineHistory = []
        self.profileImageUrl = ""
        self.routines = []
        self.streakInfo = StreakInfo()

    }
    
    init() {}

    public struct StreakInfo: Hashable, Codable {
        var averageWorkout: Double
        var weekCount: Int
        var currentStreakAmount: Int
        var longestStreak: Int

        init() {
            self.averageWorkout = 0
            self.weekCount = 0
            self.currentStreakAmount = 0
            self.longestStreak = 0
        }

        init(_ averageWorkout: Double, _ weekCount: Int, _ currentStreakAmount: Int, _ longestStreak: Int) {
            self.averageWorkout = averageWorkout
            self.weekCount = weekCount
            self.currentStreakAmount = currentStreakAmount
            self.longestStreak = longestStreak
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.averageWorkout = try container.decodeIfPresent(Double.self, forKey: .averageWorkout) ?? 0
            self.weekCount = try container.decodeIfPresent(Int.self, forKey: .weekCount) ?? 0
            self.currentStreakAmount = try container.decodeIfPresent(Int.self, forKey: .currentStreakAmount) ?? 0
            self.longestStreak = try container.decodeIfPresent(Int.self, forKey: .longestStreak) ?? 0
        }

        enum CodingKeys: String, CodingKey {
            case averageWorkout
            case weekCount
            case currentStreakAmount
            case longestStreak
        }
    }
}
