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
    }
}
