//
//  Date+Exy.swift
//  FitnessApp
//
//  Created by Jason Dubon on 8/23/23.
//

import Foundation

extension Date {

    static var startOfDay: Date {
        let calendar = Calendar.current
        return calendar.startOfDay(for: Date())
    }

    // Treats Monday as start of week
    static var startOfWeek: Date {
        let calendar = Calendar.current
        let today = Date()
        let weekday = calendar.component(.weekday, from: today)

        // Monday
        var components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today)
        components.weekday = 2

        // Calculate the start of the week date
        var startOfWeek = calendar.date(from: components) ?? Date()

        // Check if today is Sunday (weekday == 1) and adjust the startOfWeek to the previous Monday
        if weekday == 1 {
            let adjustedDate = calendar.date(byAdding: .day, value: -7, to: startOfWeek)
            startOfWeek = adjustedDate ?? startOfWeek
        }

        return startOfWeek
    }
    
    static var oneWeekAgo: Date {
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .day, value: -6, to: Date()) ?? Date()
        return calendar.startOfDay(for: date)
    }
    
    static var oneMonthAgo: Date {
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .month, value: -1, to: Date()) ?? Date()
        return calendar.startOfDay(for: date)
    }
    
    static var threeMonthsAgo: Date {
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .month, value: -3, to: Date()) ?? Date()
        return calendar.startOfDay(for: date)
    }
    
    // Returns start date and end date of given month
    func fetchMonthStartAndEndDate() -> (Date, Date) {
        let calendar = Calendar.current
        let startDateComponent = calendar.dateComponents([.year, .month], from: calendar.startOfDay(for: self))
        let startDate = calendar.date(from: startDateComponent) ?? self
        
        let endDate = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startDate) ?? self
        return (startDate, endDate)
    }
    
    func formatWorkoutDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: self)
    }
    
    func mondayDateFormat() -> String {
        let monday = Date.startOfWeek
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        return formatter.string(from: monday)
    }
    
    func monthAndYearFormat() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM YYYY"
        return formatter.string(from: self)
    }
    
    func timeOfDayGreeting() -> String {
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: self)
            
            switch hour {
            case 2..<12:
                return "Good Morning,"
            case 12..<18:
                return "Good Afternoon,"
            default:
                return "Good Evening,"
            }
        }
}
