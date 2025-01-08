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
    @Observable class ViewModel {
        var color: Color = .blue
        var date = Date.now {
            didSet {
                    if Calendar.current.component(.month, from: date) != Calendar.current.component(.month, from: oldValue) {
                        days = date.calendarDisplayDays
                    }
                }
        }
        var presentWeightEntryPopup = false
        var selectedDate = Date.now
        var currentWeight = ""
        var weightEntries = [WeightEntry]()
        let daysOfWeek = Date.capitalizedFirstLettersOfWeekdays
        let columns  = Array(repeating: GridItem(.flexible()), count: 7)
        var days: [Date] = []
        let userRoutineHistory = DataManager.shared.user.routineHistory
        var monthYearText: String {
            return date.formatted(.dateTime.month(.wide).year())
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
        
        //TODO: Delete after implementing proper weight entry system
        func addWeightEntry(weight: WeightEntry){
            if let index = self.weightEntries.firstIndex(where: {$0.entryDateString == weight.entryDateString}){
                self.weightEntries[index] = weight
            } else {
                self.weightEntries.append(weight)
            }
        }
        
        func addWeightEntry(){
            //TODO: There needs to be validation before this stage so that this wont fail
            let weight = WeightEntry(weight: Double(currentWeight) ?? 0, entryDate: selectedDate)
            if let index = self.weightEntries.firstIndex(where: {$0.entryDateString == weight.entryDateString}){
                self.weightEntries[index] = weight
            } else {
                self.weightEntries.append(weight)
                weightEntries = weightEntries.sorted(by: { $0.entryDate < $1.entryDate })
            }
            currentWeight = ""
            selectedDate = Date.now
        }
    }
}
