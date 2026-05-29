//
//  PersonalProgressViewModel.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 11/25/24.
//

import Foundation
import Observation
import SwiftUI
extension WeightChart {
    @Observable class ViewModel {
        var currentDatePickerSelection = DatePickerSelection.all
        var currentWeightEntry: WeightEntry? = nil
        var presentWeightEntryPopup = false
        var userService: UserService?

        var weightEntries: [WeightEntry] {
            userService?.user.weightHistory ?? []
        }

        var weightAxisUpperBound: Double {
            return ((weightEntries.max(by: { $0.weight < $1.weight }))?.weight ?? 200.0) + 10.0
        }

        var weightAxisLowerBound: Double {
            //Avoids possible negative number
            return max(((weightEntries.min(by: { $0.weight < $1.weight }))?.weight ?? 10) - 10.0, 0)
        }

        var filteredWeightEntries: [WeightEntry] {
            var filteredWeighEntries = [WeightEntry]()
            let upperBoundDate = Date.now
            var lowerBoundDate = Date.now

            switch currentDatePickerSelection {
            case .week:
                lowerBoundDate = Calendar.current.date(byAdding: .weekOfMonth, value: -1, to: upperBoundDate)!
            case .month:
                lowerBoundDate = Calendar.current.date(byAdding: .month, value: -1, to: upperBoundDate)!
            case .year:
                lowerBoundDate = Calendar.current.date(byAdding: .year, value: -1, to: upperBoundDate)!
            case .all:
                lowerBoundDate = weightEntries.min(by: { $0.entryDate < $1.entryDate })?.entryDate ?? upperBoundDate
            }

            filteredWeighEntries = weightEntries.filter({ $0.entryDate <= upperBoundDate && $0.entryDate >= lowerBoundDate })
            return filteredWeighEntries
        }

        func weightEntryAction(weight: WeightEntry, actionType: WeightEntryAction) {
            Task {
                do {
                    switch actionType {
                    case .create:
                        try await userService?.createWeightEntry(weight)
                    case .update:
                        try await userService?.updateWeightEntry(weight)
                    case .delete:
                        try await userService?.deleteWeightEntry(weight)
                    }
                } catch {
                    print(error)
                }
            }
        }

        func handleChartTap(date: String, weight: Double){
            if let dataPoint = self.weightEntries.first(where: { weight > ($0.weight - 1.65) && weight < ($0.weight + 1.65) && date == $0.entryDateString  }){
                self.currentWeightEntry = dataPoint
                self.presentWeightEntryPopup = true
            }

        }
    }
    
    public enum DatePickerSelection: String, CaseIterable {
        case week = "Week"
        case month = "Month"
        case year = "Year"
        case all = "All"
    }
}

