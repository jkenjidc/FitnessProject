//
//  WeightEntry.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 1/6/25.
//

import Foundation

struct WeightEntry : Identifiable, Hashable, Codable {
    var id = UUID().uuidString
    var weight: Double
    var entryDate: Date
    var entryDateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        return dateFormatter.string(from: entryDate)
    }
    
    init(weight: Double) {
        self.weight = weight
        self.entryDate = Date.now
    }
    init(weight: Double, entryDate: Date) {
        self.weight = weight
        self.entryDate = entryDate
    }
    
    
    static let sampleWeightEntryList = [WeightEntry(weight: 156.0),
                                        WeightEntry(weight: 167.0),
                                        WeightEntry(weight: 167.0),
                                        WeightEntry(weight: 165.4, entryDate: Calendar.current.date(byAdding: .month, value: -1, to: Date.now)!),
                                        WeightEntry(weight: 177.3, entryDate: Calendar.current.date(byAdding: .month, value: -2, to: Date.now)!),
                                        WeightEntry(weight: 170.5, entryDate: Calendar.current.date(byAdding: .month, value: -3, to: Date.now)!),
                                        WeightEntry(weight: 170.5, entryDate: Calendar.current.date(byAdding: .month, value: -4, to: Date.now)!)]
    
}
