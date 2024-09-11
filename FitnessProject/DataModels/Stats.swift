//
//  Stats.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/10/24.
//

import Foundation

struct Stats: Identifiable, Codable, Hashable {
    var id = UUID().uuidString
    var oneRepMax: [Date: Double]
    var totalReps: [Date:Int]
    
    init(oneRepMax: [Date : Double], totalReps: [Date : Int]) {
        self.oneRepMax = oneRepMax
        self.totalReps = totalReps
    }
    
    static let example = Stats(oneRepMax: [:], totalReps: [:])
}
