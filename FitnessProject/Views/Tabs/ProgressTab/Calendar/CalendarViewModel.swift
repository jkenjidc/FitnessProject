//
//  CalendarViewModel.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 6/20/25.
//

import Foundation
import SwiftUI

extension CalendarView {
    @Observable class ViewModel {
        var date = Date.now {
            didSet {
                    if Calendar.current.component(.month, from: date) != Calendar.current.component(.month, from: oldValue) {
                        days = date.calendarDisplayDays
                    }
                }
        }
        var monthYearText: String {
            return date.formatted(.dateTime.month(.wide).year())
        }
        let daysOfWeek = Date.capitalizedFirstLettersOfWeekdays
        var color: Color = .blue
        let columns  = Array(repeating: GridItem(.flexible()), count: 7)
        var days: [Date] = []


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

        func shouldShowUnderline(_ day: Date) -> Bool {
            for routine in DataManager.shared.routines {
                if routine.daysToDo.contains(day.formatted(Date.FormatStyle().weekday(.wide))) {
                    return true
                }
            }
            return false
        }
    }
}
