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
    
    static var startOfWeek: Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())
        components.weekday = 2
        return calendar.date(from: components) ?? Date()
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
    
}
