//
//  WeightEntry.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 1/6/25.
//

import Foundation

struct WeightEntry : Identifiable, Hashable {
    let id = UUID().uuidString
    var weight: Double
    var entryDate: Date
    var entryDateString: DateComponents {
        Calendar.current.dateComponents([.month, .year], from: entryDate)
    }
    
    init(weight: Double) {
        self.weight = weight
        self.entryDate = Date.now
    }
    init(weight: Double, entryDate: Date) {
        self.weight = weight
        self.entryDate = entryDate
    }
}
