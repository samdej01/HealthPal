import Foundation
import HealthKit

protocol HealthManagerType {
    func requestHealthKitAccess() async throws
    func fetchTodayCaloriesBurned(completion: @escaping(Result<Double, Error>) -> Void)
    func fetchTodayCalories() async throws -> Double
    func fetchTodayExerciseTime(completion: @escaping(Result<Double, Error>) -> Void)
    func fetchTodayExerciseTime() async throws -> Double
    func fetchTodayStandHours(completion: @escaping(Result<Int, Error>) -> Void)
    func fetchTodayStandHours() async throws -> Int
    func fetchTodaySteps(completion: @escaping(Result<Activity, Error>) -> Void)
    func fetchTodaySteps() async throws -> Activity
    func fetchCurrentWeekWorkoutStats(completion: @escaping (Result<[Activity], Error>) -> Void)
    func fetchCurrentWeekActivities() async throws -> [Activity]
    func fetchWorkoutsForMonth(month: Date, completion: @escaping (Result<[Workout], Error>) -> Void)
    func fetchRecentWorkouts() async throws -> [Workout]
    func fetchDailySteps(startDate: Date, completion: @escaping (Result<[DailyStepModel], Error>) -> Void)
    func fetchOneWeekStepData() async throws -> [DailyStepModel]
    func fetchOneMonthStepData() async throws -> [DailyStepModel]
    func fetchThreeMonthsStepData() async throws -> [DailyStepModel]
    func fetchYTDAndOneYearChartData() async throws -> YearChartDataResult
    func fetchYTDAndOneYearChartData(completion: @escaping (Result<YearChartDataResult, Error>) -> Void)
    func fetchCurrentWeekStepCount(completion: @escaping (Result<Double, Error>) -> Void)
}

final class HealthManager: HealthManagerType {
    
    static let shared = HealthManager()
    
    private let healthStore = HKHealthStore()
    
    @MainActor
    func requestHealthKitAccess() async throws {
        let calories = HKQuantityType(.activeEnergyBurned)
        let exercise = HKQuantityType(.appleExerciseTime)
        let stand = HKCategoryType(.appleStandHour)
        let steps = HKQuantityType(.stepCount)
        let workouts = HKSampleType.workoutType()
        
        let healthTypes: Set = [calories, exercise, stand, steps, workouts]
        try await healthStore.requestAuthorization(toShare: [], read: healthTypes)
    }
    
    /// Fetches the total calories burned today.
    ///
    /// Uses HealthKit to fetch the total number of calories burned from the start of the day until now.
    ///
    /// - Parameter completion: A completion handler that returns either the total calories burned as `Double` or an error.
    func fetchTodayCaloriesBurned(completion: @escaping(Result<Double, Error>) -> Void) {
        let calories = HKQuantityType(.activeEnergyBurned)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: calories, quantitySamplePredicate: predicate) { _, results, error in
            guard let quantity = results?.sumQuantity(), error == nil else {
                completion(.failure(error!))
                return
            }
            
            let calorieCount = quantity.doubleValue(for: .kilocalorie())
            completion(.success(calorieCount))
        }
        
        healthStore.execute(query)
    }
    
    func fetchTodayCalories() async throws -> Double {
        try await withCheckedThrowingContinuation({ continuation in
            fetchTodayCaloriesBurned { result in
                switch result {
                case .success(let calories):
                    continuation.resume(returning: calories)
                case .failure(let failure):
                    continuation.resume(throwing: failure)
                }
            }
        })
    }
    
    /// Fetches the total exercise time for the current day.
    ///
    /// This function queries HealthKit for the sum of apple exercise time from the start of the current day until now.
    /// - Parameter completion: A completion handler that returns a result containing either the total exercise time in minutes as `Double` or an error.
    func fetchTodayExerciseTime(completion: @escaping(Result<Double, Error>) -> Void) {
        let exercise = HKQuantityType(.appleExerciseTime)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: exercise, quantitySamplePredicate: predicate) { _, results, error in
            guard let quantity = results?.sumQuantity(), error == nil else {
                completion(.failure(error!))
                return
            }
            
            let exerciseTime = quantity.doubleValue(for: .minute())
            completion(.success(exerciseTime))
        }
        
        healthStore.execute(query)
    }
    
    func fetchTodayExerciseTime() async throws -> Double {
        try await withCheckedThrowingContinuation({ continuation in
            fetchTodayExerciseTime { result in
                continuation.resume(with: result)
            }
        })
    }
    
    /// Fetches the number of stand hours for the current day.
    ///
    /// This function queries HealthKit for the count of apple stand hours from the start of the current day until now.
    /// - Parameter completion: A completion handler that returns a result containing either the number of stand hours as `Int` or an error.
    func fetchTodayStandHours(completion: @escaping(Result<Int, Error>) -> Void) {
        let stand = HKCategoryType(.appleStandHour)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKSampleQuery(sampleType: stand, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, results, error in
            guard let samples = results as? [HKCategorySample], error == nil else {
                completion(.failure(error!))
                return
            }
            
            let standCount = samples.filter({ $0.value == 0 }).count
            completion(.success(standCount))
        }
        
        healthStore.execute(query)
    }
    
    func fetchTodayStandHours() async throws -> Int {
        try await withCheckedThrowingContinuation({ continuation in
            fetchTodayStandHours { result in
                continuation.resume(with: result)
            }
        })
    }
    
    // MARK: Fitness Activity
    
    /// Fetches the number of steps for the current day.
    ///
    /// This function queries HealthKit for the sum of steps taken from the start of the current day until now, comparing it against the user's step goal.
    /// - Parameter completion: A completion handler that returns a result containing an `Activity` object with today's step count or an error.
    func fetchTodaySteps(completion: @escaping(Result<Activity, Error>) -> Void) {
        let steps = HKQuantityType(.stepCount)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate) { _, results, error in
            guard let quantity = results?.sumQuantity(), error == nil else {
                completion(.success(Activity(title: "Today Steps", subtitle: "Goal: 800", image: "figure.walk", tintColor: .green, amount: "---")))
                return
            }
            
            let steps = quantity.doubleValue(for: .count())
            let stepsGoal = UserDefaults.standard.value(forKey: "stepsGoal") ?? 7500
            let activity = Activity(title: "Today Steps", subtitle: "Goal: \(stepsGoal)", image: "figure.walk", tintColor: .green, amount: steps.formattedNumberString())
            completion(.success(activity))
        }
        
        healthStore.execute(query)
    }
    
    func fetchTodaySteps() async throws -> Activity {
        try await withCheckedThrowingContinuation({ continuation in
            fetchTodaySteps { result in
                continuation.resume(with: result)
            }
        })
    }
    
    /// Fetches the current week's workout statistics.
    ///
    /// This function queries HealthKit for workout samples from the start of the current week until now and categorizes them by type to calculate the total duration of each workout type.
    /// - Parameter completion: A completion handler that returns a result containing a list of `Activity` objects representing the week's workout statistics or an error.
    func fetchCurrentWeekWorkoutStats(completion: @escaping (Result<[Activity], Error>) -> Void) {
        let workouts = HKSampleType.workoutType()
        let predicate = HKQuery.predicateForSamples(withStart: .startOfWeek, end: Date())
        let query = HKSampleQuery(sampleType: workouts, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { [weak self] _, results, error in
            guard let workouts = results as? [HKWorkout], let self = self, error == nil else {
                completion(.failure(error!))
                return
            }
            
            // Only tracking acitivties we are interested in
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
    
    /// Generates `Activity` objects from workout durations.
    ///
    /// This helper function creates `Activity` objects for various types of workouts based on their durations.
    private func generateActivitiesFromDurations(running: Int, strength: Int, soccer: Int, basketball: Int, stairs: Int, kickboxing: Int) -> [Activity] {
        return [
            Activity(title: "Running", subtitle: "This week", image: "figure.run", tintColor: .green, amount: "\(running) mins"),
            Activity(title: "Strength Training", subtitle: "This week", image: "dumbbell", tintColor: .blue, amount: "\(strength) mins"),
            Activity(title: "Soccer", subtitle: "This week", image: "figure.soccer", tintColor: .indigo, amount: "\(soccer) mins"),
            Activity(title: "Basketball", subtitle: "This week", image: "figure.basketball", tintColor: .green, amount: "\(basketball) mins"),
            Activity(title: "Stairstepper", subtitle: "This week", image: "figure.stairs", tintColor: .green, amount: "\(stairs) mins"),
            Activity(title: "Kickboxing", subtitle: "This week", image: "figure.kickboxing", tintColor: .green, amount: "\(kickboxing) mins"),
        ]
    }
    
    func fetchCurrentWeekActivities() async throws -> [Activity] {
        try await withCheckedThrowingContinuation({ continuation in
            fetchCurrentWeekWorkoutStats { result in
                continuation.resume(with: result)
            }
        })
    }
    
    // MARK: Recent Workouts
    
    /// Fetches workout data for a specified month.
    ///
    /// Queries HealthKit for workouts within the specified month, sorting them by their start date. This method is useful for generating workout cards displayed on the app's home screen.
    ///
    /// - Parameters:
    ///   - month: The month for which to fetch workout data, represented as a `Date`.
    ///   - completion: A completion handler that returns a result containing either an array of `Workout` objects for the specified month or an error.
    func fetchWorkoutsForMonth(month: Date, completion: @escaping (Result<[Workout], Error>) -> Void) {
        let workouts = HKSampleType.workoutType()
        let (startDate, endDate) = month.fetchMonthStartAndEndDate()
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        let query = HKSampleQuery(sampleType: workouts, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { _, results, error in
            guard let workouts = results as? [HKWorkout], error == nil else {
                completion(.failure(error!))
                return
            }
            
            // Generates workout cards that will be displayed on home screen
            let workoutsArray = workouts.map( { Workout(title: $0.workoutActivityType.name, image: $0.workoutActivityType.image, tintColor: $0.workoutActivityType.color, duration: "\(Int($0.duration)/60) mins", date: $0.startDate, calories: ($0.totalEnergyBurned?.doubleValue(for: .kilocalorie()).formattedNumberString() ?? "-") + " kcal") })
            completion(.success(workoutsArray))
        }
        healthStore.execute(query)
    }
    
    func fetchRecentWorkouts() async throws -> [Workout] {
        try await withCheckedThrowingContinuation({ continuation in
            fetchWorkoutsForMonth(month: .now) { result in
                continuation.resume(with: result)
            }
        })
    }
    
}

    // MARK: ChartsView Data
extension HealthManager {
    
    /// Fetches daily step count starting from a specified date.
    ///
    /// Initiates a query to HealthKit for the daily number of steps, aggregating data by day from the start date to the current date. This method supports rendering step count trends over time.
    ///
    /// - Parameters:
    ///   - startDate: The start date from which to begin aggregating step data.
    ///   - completion: A completion handler that returns a result containing an array of `DailyStepModel` instances representing the daily step counts or an error.
    func fetchDailySteps(startDate: Date, completion: @escaping (Result<[DailyStepModel], Error>) -> Void) {
        let steps = HKQuantityType(.stepCount)
        let interval = DateComponents(day: 1)
        
        let query = HKStatisticsCollectionQuery(quantityType: steps, quantitySamplePredicate: nil, anchorDate: startDate, intervalComponents: interval)
        
        // Method to query health data for each date of a given period
        query.initialResultsHandler = { _, results, error in
            guard let result = results, error == nil else {
                completion(.failure(error!))
                return
            }
            
            var dailySteps = [DailyStepModel]()
            
            result.enumerateStatistics(from: startDate, to: Date()) { statistics, stop in
                dailySteps.append(DailyStepModel(date: statistics.startDate, count: Int(statistics.sumQuantity()?.doubleValue(for: .count()) ?? 0)))
            }
            completion(.success(dailySteps))
        }
        healthStore.execute(query)
    }
    
    func fetchOneWeekStepData() async throws -> [DailyStepModel] {
        try await withCheckedThrowingContinuation({ continuation in
            fetchDailySteps(startDate: .oneWeekAgo) { result in
                switch result {
                case .success(let steps):
                    continuation.resume(returning: steps)
                case .failure(let failure):
                    continuation.resume(throwing: failure)
                }
            }
        })
    }
    
    func fetchOneMonthStepData() async throws -> [DailyStepModel] {
        try await withCheckedThrowingContinuation({ continuation in
            fetchDailySteps(startDate: .oneMonthAgo) { result in
                switch result {
                case .success(let steps):
                    continuation.resume(returning: steps)
                case .failure(let failure):
                    continuation.resume(throwing: failure)
                }
            }
        })
    }

    func fetchThreeMonthsStepData() async throws -> [DailyStepModel] {
        try await withCheckedThrowingContinuation({ continuation in
            fetchDailySteps(startDate: .threeMonthsAgo) { result in
                switch result {
                case .success(let steps):
                    continuation.resume(returning: steps)
                case .failure(let failure):
                    continuation.resume(throwing: failure)
                }
            }
        })
    }
    
    /// Fetches step count data for the current year-to-date (YTD) and the past one year.
    ///
    /// This method executes multiple queries to HealthKit to compile step count data by month for the previous year and the current year to date. It's designed to provide a comprehensive view of the user's step activity over these periods.
    ///
    /// - Parameter completion: A completion handler that returns a result containing `YearChartDataResult` which includes arrays of `MonthlyStepModel` for both the YTD and one-year periods or an error.
    func fetchYTDAndOneYearChartData(completion: @escaping (Result<YearChartDataResult, Error>) -> Void) {
        
        let steps = HKQuantityType(.stepCount)
        let calendar = Calendar.current
        
        var oneYearMonths = [MonthlyStepModel]()
        var ytdMonths = [MonthlyStepModel]()
        // Note: Query is imbedded in a for loop to fetch data for previous 12 months
        // Approach could be improved as running into an error for a given month will return failure/error for the entire call
        for i in 0...11 {
            let month = calendar.date(byAdding: .month, value: -i, to: Date()) ?? Date()
            let (startOfMonth, endOfMonth) = month.fetchMonthStartAndEndDate()
            let predicate = HKQuery.predicateForSamples(withStart: startOfMonth, end: endOfMonth)
            let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate) { _, results, error in
                if let error = error, error.localizedDescription != "No data available for the specified predicate." {
                    completion(.failure(error))
                }
                
                let steps = results?.sumQuantity()?.doubleValue(for: .count()) ?? 0
                
                if i == 0 {
                    oneYearMonths.append(MonthlyStepModel(date: month, count: Int(steps)))
                    ytdMonths.append(MonthlyStepModel(date: month, count: Int(steps)))
                } else {
                    oneYearMonths.append(MonthlyStepModel(date: month, count: Int(steps)))
                    if calendar.component(.year, from: Date()) == calendar.component(.year, from: month) {
                        ytdMonths.append(MonthlyStepModel(date: month, count: Int(steps)))
                    }
                }
                
                // On last interation of the loop (last month), call completion success
                if i == 11 {
                    completion(.success(YearChartDataResult(ytd: ytdMonths, oneYear: oneYearMonths)))
                }
            }
            healthStore.execute(query)
        }
    }
    
    func fetchYTDAndOneYearChartData() async throws -> YearChartDataResult {
        try await requestHealthKitAccess()
        return try await withCheckedThrowingContinuation({ continuation in
            fetchYTDAndOneYearChartData { result in
                switch result {
                case .success(let res):
                    continuation.resume(returning: res)
                case .failure(let failure):
                    continuation.resume(throwing: failure)
                }
            }
        })
    }
}

   // MARK: Leaderboard View
extension HealthManager {

    /// Fetches the total step count for the current week.
    ///
    /// Queries HealthKit for the sum of steps taken from the start of the current week to the present. This data is used to populate the leaderboard, comparing the user's activity against others.
    ///
    /// - Parameter completion: A completion handler that returns a result containing the total step count as a `Double` or an error.
    func fetchCurrentWeekStepCount(completion: @escaping (Result<Double, Error>) -> Void) {
        let steps = HKQuantityType(.stepCount)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfWeek, end: Date())

        let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate) { _, results, error in
            guard let quantity = results?.sumQuantity(), error == nil else {
                completion(.failure(error!))
                return
            }
            
            let steps = quantity.doubleValue(for: .count())
            completion(.success(steps))
        }
        
        healthStore.execute(query)
    }
    
}
