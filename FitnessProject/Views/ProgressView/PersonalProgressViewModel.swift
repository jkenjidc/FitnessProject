//
//  PersonalProgressViewModel.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 11/25/24.
//

import Foundation
import Observation
import SwiftUI
extension PersonalProgressView {
    public enum DatePickerSelection: String, CaseIterable {
        case week = "Week"
        case month = "Month"
        case year = "Year"
        case all = "All"
    }
    @Observable class ViewModel {
        var color: Color = .blue
        var date = Date.now {
            didSet {
                    if Calendar.current.component(.month, from: date) != Calendar.current.component(.month, from: oldValue) {
                        days = date.calendarDisplayDays
                    }
                }
        }
        var currentDatePickerSelection = DatePickerSelection.all
        var currentWeightEntry: WeightEntry? = nil
        var presentWeightEntryPopup = false
        var weightEntries = [WeightEntry]()
        let daysOfWeek = Date.capitalizedFirstLettersOfWeekdays
        let columns  = Array(repeating: GridItem(.flexible()), count: 7)
        var days: [Date] = []
        let userRoutineHistory = DataManager.shared.user.routineHistory
        var monthYearText: String {
            return date.formatted(.dateTime.month(.wide).year())
        }
        
        var weightAxisUpperBound: Double {
            return ((weightEntries.max(by: { $0.weight < $1.weight }))?.weight ?? 200.0) + 10.0
        }
        
        var weightAxisLowerBound: Double {
            //Avoids possible negative number
            return max(((weightEntries.min(by: { $0.weight < $1.weight }))?.weight ?? 10) - 10.0, 0)
        }

        func shouldShowUnderline(_ day: Date) -> Bool {
            for routine in DataManager.shared.routines {
                if routine.daysToDo.contains(day.formatted(Date.FormatStyle().weekday(.wide))) {
                    return true
                }
            }
            return false
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
        
        func adjustMonthByAmount(value: Int) {
            if let newDate = Calendar.current.date(byAdding: .month, value: value, to: date) {
                date = newDate
            }
        }
        
        
        func getDayColor(day: Date, routineHistory: [RoutineHistoryRecord]?) -> Color {
            var dayColor =  Date.now.startOfDay == day.startOfDay ? .secondary.opacity(0.3) :
                color.opacity(0.3)
            if let routineHistory = routineHistory {
                let calendar = Calendar.current
                let hasMatchingDate = routineHistory.contains { routine in
                    calendar.isDate(routine.dateDone, inSameDayAs: day)
                }
                dayColor = hasMatchingDate ? Color.orange.opacity(0.3) : dayColor
                
            }
            return dayColor
        }
        
        func weightEntryAction(weight: WeightEntry, actionType: WeightEntryAction) {
            switch actionType {
            case .create:
                createWeightEntry(weight: weight)
            case .update:
                updateWeightEntry(weight: weight)
            case .delete:
                deleteWeightEntry(weight: weight)
            }
        }
        
        func createWeightEntry(weight: WeightEntry){
            if let index = self.weightEntries.firstIndex(where: {$0.entryDateString == weight.entryDateString}){
                self.weightEntries[index] = weight
            } else {
                self.weightEntries.append(weight)
                weightEntries = weightEntries.sorted(by: { $0.entryDate < $1.entryDate })
            }
            updateUserWeightEntries()
        }
        
        func updateWeightEntry(weight: WeightEntry) {
            guard let index = self.weightEntries.firstIndex(where: {$0.id == weight.id}) else { return }
            weightEntries[index] = weight
            updateUserWeightEntries()
        }
        
        func deleteWeightEntry(weight: WeightEntry) {
            guard let index = self.weightEntries.firstIndex(where: {$0.id == weight.id}) else { return }
            weightEntries.remove(at: index)
            updateUserWeightEntries()
        }
        
        func updateUserWeightEntries() {
            DataManager.shared.user.weightHistory = weightEntries
            Task{
                do {
                   try await DataManager.shared.updateCurrentUser()
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
}

