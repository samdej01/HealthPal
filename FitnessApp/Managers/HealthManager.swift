//
//  HealthManager.swift
//  FitnessApp
//
//  Created by Jason Dubon on 8/3/23.
//

import Foundation
import HealthKit

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
    
}

extension Double {
    
    func formattedNumberString() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        
        return formatter.string(from: NSNumber(value: self)) ?? "0"
    }
    
}

class HealthManager {
    
    static let shared = HealthManager()
    
    let healthStore = HKHealthStore()
    
    private init () {
        Task {
            do {
                try await requestHealthKitAccess()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func requestHealthKitAccess() async throws {
        let calories = HKQuantityType(.activeEnergyBurned)
        let exercise = HKQuantityType(.appleExerciseTime)
        let stand = HKCategoryType(.appleStandHour)
        let steps = HKQuantityType(.stepCount)
        let workouts = HKSampleType.workoutType()
        
        let healthTypes: Set = [calories, exercise, stand, steps, workouts]
        try await healthStore.requestAuthorization(toShare: [], read: healthTypes)
    }
    
    func fetchTodayCaloriesBurned(completion: @escaping(Result<Double, Error>) -> Void) {
        let calories = HKQuantityType(.activeEnergyBurned)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: calories, quantitySamplePredicate: predicate) { _, results, error in
            guard let quantity = results?.sumQuantity(), error == nil else {
                completion(.failure(URLError(.badURL)))
                return
            }
            
            let calorieCount = quantity.doubleValue(for: .kilocalorie())
            completion(.success(calorieCount))
        }
        
        healthStore.execute(query)
    }
    
    func fetchTodayExerciseTime(completion: @escaping(Result<Double, Error>) -> Void) {
        let exercise = HKQuantityType(.appleExerciseTime)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: exercise, quantitySamplePredicate: predicate) { _, results, error in
            guard let quantity = results?.sumQuantity(), error == nil else {
                completion(.failure(URLError(.badURL)))
                return
            }
            
            let exerciseTime = quantity.doubleValue(for: .minute())
            completion(.success(exerciseTime))
        }
        
        healthStore.execute(query)
    }
    
    func fetchTodayStandHours(completion: @escaping(Result<Int, Error>) -> Void) {
        let stand = HKCategoryType(.appleStandHour)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKSampleQuery(sampleType: stand, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, results, error in
            guard let samples = results as? [HKCategorySample], error == nil else {
                completion(.failure(URLError(.badURL)))
                return
            }
            
            let standCount = samples.filter({ $0.value == 0 }).count
            completion(.success(standCount))
        }
        
        healthStore.execute(query)
    }
    
    // MARK: Fitness Activity
    func fetchTodaySteps(completion: @escaping(Result<Activity, Error>) -> Void) {
        let steps = HKQuantityType(.stepCount)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate) { _, results, error in
            guard let quantity = results?.sumQuantity(), error == nil else {
                completion(.failure(URLError(.badURL)))
                return
            }
            
            let steps = quantity.doubleValue(for: .count())
            let activity = Activity(title: "Today Steps", subtitle: "Goal: 800", image: "figure.walk", tintColor: .green, amount: steps.formattedNumberString())
            completion(.success(activity))
        }
        
        healthStore.execute(query)
    }
    
    func fetchCurrentWeekWorkoutStats(completion: @escaping (Result<[Activity], Error>) -> Void) {
        let workouts = HKSampleType.workoutType()
        let predicate = HKQuery.predicateForSamples(withStart: .startOfWeek, end: Date())
        let query = HKSampleQuery(sampleType: workouts, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { [weak self] _, results, error in
            guard let workouts = results as? [HKWorkout], let self = self, error == nil else {
                completion(.failure(URLError(.badURL)))
                return
            }
            
            var runningCount: Int = 0
            var strengthCount: Int = 0
            var soccerCount: Int = 0
            var basketballCount: Int = 0
            var stairsCount: Int = 0
            var kickboxingCount: Int = 0
            
            for workout in workouts {
                let duration = Int(workout.duration)/60
                if workout.workoutActivityType == .running {
                    runningCount += duration
                } else if workout.workoutActivityType == .traditionalStrengthTraining {
                    strengthCount += duration
                } else if workout.workoutActivityType == .soccer {
                    soccerCount += duration
                } else if workout.workoutActivityType == .basketball {
                    basketballCount += duration
                } else if workout.workoutActivityType == .stairClimbing {
                    stairsCount += duration
                } else if workout.workoutActivityType == .kickboxing {
                    kickboxingCount += duration
                }
            }
            
            completion(.success(self.generateActivitiesFromDurations(running: runningCount, strength: strengthCount, soccer: soccerCount, basketball: basketballCount, stairs: stairsCount, kickboxing: kickboxingCount)))
        }
        
        healthStore.execute(query)
    }
    
    func generateActivitiesFromDurations(running: Int, strength: Int, soccer: Int, basketball: Int, stairs: Int, kickboxing: Int) -> [Activity] {
        return [
            Activity(title: "Running", subtitle: "This week", image: "figure.run", tintColor: .green, amount: "\(running) mins"),
            Activity(title: "Strength Training", subtitle: "This week", image: "dumbbell", tintColor: .blue, amount: "\(strength) mins"),
            Activity(title: "Soccer", subtitle: "This week", image: "figure.soccer", tintColor: .indigo, amount: "\(soccer) mins"),
            Activity(title: "Basketball", subtitle: "This week", image: "figure.basketball", tintColor: .green, amount: "\(basketball) mins"),
            Activity(title: "Stairstepper", subtitle: "This week", image: "figure.stairs", tintColor: .green, amount: "\(stairs) mins"),
            Activity(title: "Kickboxing", subtitle: "This week", image: "figure.kickboxing", tintColor: .green, amount: "\(kickboxing) mins"),
        ]
    }
    
    // MARK: Recent Workouts
    func fetchWorkoutsForMonth(month: Date, completion: @escaping (Result<[Workout], Error>) -> Void) {
        let workouts = HKSampleType.workoutType()
        let (startDate, endDate) = month.fetchMonthStartAndEndDate()
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        let query = HKSampleQuery(sampleType: workouts, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { _, results, error in
            guard let workouts = results as? [HKWorkout], error == nil else {
                completion(.failure(URLError(.badURL)))
                return
            }
            
            let workoutsArray = workouts.map( { Workout(id: nil, title: $0.workoutActivityType.name, image: $0.workoutActivityType.image, tintColor: $0.workoutActivityType.color, duration: "\(Int($0.duration)/60) mins", date: $0.startDate.formatWorkoutDate(), calories: ($0.totalEnergyBurned?.doubleValue(for: .kilocalorie()).formattedNumberString() ?? "-") + " kcal") })
            completion(.success(workoutsArray))
        }
        healthStore.execute(query)
    }
    
}

    // MARK: ChartsView Data
extension HealthManager {
    
    struct YearChartDataResult {
        let ytd: [MonthlyStepModel]
        let oneYear: [MonthlyStepModel]
    }
    
    func fetchYTDAndOneYearChartData(completion: @escaping (Result<YearChartDataResult, Error>) -> Void) {
        let steps = HKQuantityType(.stepCount)
        let calendar = Calendar.current
        
        var oneYearMonths = [MonthlyStepModel]()
        var ytdMonths = [MonthlyStepModel]()
        for i in 0...11 {
            let month = calendar.date(byAdding: .month, value: -i, to: Date()) ?? Date()
            let (startOfMonth, endOfMonth) = month.fetchMonthStartAndEndDate()
            let predicate = HKQuery.predicateForSamples(withStart: startOfMonth, end: endOfMonth)
            let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate) { _, results, error in
                guard let steps = results?.sumQuantity()?.doubleValue(for: .count()), error == nil else {
                    completion(.failure(URLError(.badURL)))
                    return
                }
                
                if i == 0 {
                    oneYearMonths.append(MonthlyStepModel(date: month, count: Int(steps)))
                    ytdMonths.append(MonthlyStepModel(date: month, count: Int(steps)))
                } else {
                    oneYearMonths.append(MonthlyStepModel(date: month, count: Int(steps)))
                    if calendar.component(.year, from: Date()) == calendar.component(.year, from: month) {
                        ytdMonths.append(MonthlyStepModel(date: month, count: Int(steps)))
                    }
                }
                
                if i == 11 {
                    completion(.success(YearChartDataResult(ytd: ytdMonths, oneYear: oneYearMonths)))
                }
            }
            healthStore.execute(query)
        }
        
    }
}
