//
//  Date+Extension.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 11/25/24.
//

import Foundation

extension Date {
    static var capitalizedFirstLettersOfWeekdays: [String] {
        let calendar = Calendar.current
        let weekdays = calendar.shortWeekdaySymbols
        
        return weekdays.map { weekday in
            guard let firstLetter = weekday.first else { return "" }
            return String(firstLetter).capitalized
        }
    }
    
    var startOfMonth: Date {
        Calendar.current.dateInterval(of: .month, for: self)!.start
    }
    
    var endOfMonth: Date {
        let lastDay = Calendar.current.dateInterval(of: .month, for: self)!.end
        return Calendar.current.date(byAdding: .day, value: -1, to: lastDay)!
    }
    
    var startOfPreviousMonth: Date {
        let dayInPreviousMonth =  Calendar.current.date(byAdding: .month, value: -1, to: self)!
        return dayInPreviousMonth.startOfMonth
    }
    
    var numberOfDaysInMonth: Int {
        Calendar.current.component(.day, from: endOfMonth)
    }
    
    var sundayBeforeStart: Date {
        let startOfMonthWeekday = Calendar.current.component(.weekday, from: startOfMonth)
        let numberFromPreviousMonth = startOfMonthWeekday - 1
        return Calendar.current.date(byAdding: .day, value: -numberFromPreviousMonth, to: startOfMonth)!
    }
    
    var calendarDisplayDays: [Date] {
        var days: [Date] = []
        
        for daysOffset in 0..<numberOfDaysInMonth {
            let newDay = Calendar.current.date(byAdding: .day, value: daysOffset, to: startOfMonth)
            days.append(newDay!)
        }
        
        for dayOffset in 0..<startOfPreviousMonth.numberOfDaysInMonth {
            let newDay = Calendar.current.date(byAdding: .day, value: dayOffset, to: startOfPreviousMonth)
            days.append(newDay!)
        }
        
        return days.filter { $0 >= sundayBeforeStart && $0 <= endOfMonth}.sorted(by: <)
    }
    
    var monthInt: Int {
        Calendar.current.component(.month, from: self)
    }
    
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }

    func areDatesInSameWeek(_ date2: Date, calendar: Calendar = .current) -> Bool {
        let components1 = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        let components2 = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date2)

        return components1.yearForWeekOfYear == components2.yearForWeekOfYear &&
               components1.weekOfYear == components2.weekOfYear
    }

    static func nextDayNoonCentralTime() -> Date {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "America/Chicago")!

        let now = Date()
        var components = calendar.dateComponents([.year, .month, .day], from: now)
        components.hour = 12
        components.minute = 0
        components.second = 0

        guard let noonToday = calendar.date(from: components) else {
                // Fallback to the next day at noon if something goes wrong
                return calendar.date(byAdding: .day, value: 1, to: now) ?? now
            }

            // If noon today is in the future, return it; otherwise, return noon tomorrow
            if noonToday > now {
                return noonToday
            } else {
                return calendar.date(byAdding: .day, value: 1, to: noonToday) ?? noonToday
            }
    }

    static func threeMonthsFromToday() -> Date {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "America/Chicago")!

        let now = Date()

        guard let threeMonthsLater = calendar.date(byAdding: .month, value: 3, to: now) else {
            // Fallback to 90 days from now if something goes wrong
            return calendar.date(byAdding: .day, value: 90, to: now) ?? now
        }

        return threeMonthsLater
    }

    var weekdayString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: self)
    }
}
