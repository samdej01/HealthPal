import Foundation
@testable import FitnessApp

class MockHealthManager: HealthManagerType {
    func fetchTodayCaloriesBurned(completion: @escaping (Result<Double, any Error>) -> Void) {
        <#code#>
    }
    
    func fetchTodayExerciseTime(completion: @escaping (Result<Double, any Error>) -> Void) {
        <#code#>
    }
    
    func fetchTodayStandHours(completion: @escaping (Result<Int, any Error>) -> Void) {
        <#code#>
    }
    
    func fetchTodaySteps(completion: @escaping (Result<FitnessApp.Activity, any Error>) -> Void) {
        <#code#>
    }
    
    func fetchCurrentWeekWorkoutStats(completion: @escaping (Result<[FitnessApp.Activity], any Error>) -> Void) {
        <#code#>
    }
    
    func fetchWorkoutsForMonth(month: Date, completion: @escaping (Result<[FitnessApp.Workout], any Error>) -> Void) {
        <#code#>
    }
    
    // MARK: - Mock Results
    var requestHealthKitAccessCalled = false
    var fetchTodayCaloriesResult: Result<Double, Error>?
    var fetchTodayExerciseTimeResult: Result<Double, Error>?
    var fetchTodayStandHoursResult: Result<Int, Error>?
    var fetchTodayStepsResult: Result<FitnessApp.Activity, Error>?
    var fetchCurrentWeekActivitiesResult: Result<[FitnessApp.Activity], Error>?
    var fetchRecentWorkoutsResult: Result<[FitnessApp.Workout], Error>?
    var fetchOneWeekStepDataResult: Result<[FitnessApp.DailyStepModel], Error>?
    var fetchOneMonthStepDataResult: Result<[FitnessApp.DailyStepModel], Error>?
    var fetchThreeMonthsStepDataResult: Result<[FitnessApp.DailyStepModel], Error>?
    var fetchYTDAndOneYearChartDataResult: Result<FitnessApp.YearChartDataResult, Error>?
    var fetchTodaySleepHoursResult: Result<Double, Error>?
    var fetchLatestHeartRateResult: Result<Double, Error>?

    // MARK: - Protocol Methods
    func requestHealthKitAccess() async throws {
        requestHealthKitAccessCalled = true
    }

    func fetchTodayCalories() async throws -> Double {
        switch fetchTodayCaloriesResult {
        case .success(let value): return value
        case .failure(let error): throw error
        case .none: throw NSError(domain: "MockHealthManager", code: 1, userInfo: nil)
        }
    }

    func fetchTodayExerciseTime() async throws -> Double {
        switch fetchTodayExerciseTimeResult {
        case .success(let value): return value
        case .failure(let error): throw error
        case .none: throw NSError(domain: "MockHealthManager", code: 1, userInfo: nil)
        }
    }

    func fetchTodayStandHours() async throws -> Int {
        switch fetchTodayStandHoursResult {
        case .success(let value): return value
        case .failure(let error): throw error
        case .none: throw NSError(domain: "MockHealthManager", code: 1, userInfo: nil)
        }
    }

    func fetchTodaySteps() async throws -> FitnessApp.Activity {
        switch fetchTodayStepsResult {
        case .success(let value): return value
        case .failure(let error): throw error
        case .none: throw NSError(domain: "MockHealthManager", code: 1, userInfo: nil)
        }
    }

    func fetchCurrentWeekActivities() async throws -> [FitnessApp.Activity] {
        switch fetchCurrentWeekActivitiesResult {
        case .success(let value): return value
        case .failure(let error): throw error
        case .none: throw NSError(domain: "MockHealthManager", code: 1, userInfo: nil)
        }
    }

    func fetchRecentWorkouts() async throws -> [FitnessApp.Workout] {
        switch fetchRecentWorkoutsResult {
        case .success(let value): return value
        case .failure(let error): throw error
        case .none: throw NSError(domain: "MockHealthManager", code: 1, userInfo: nil)
        }
    }

    func fetchOneWeekStepData() async throws -> [FitnessApp.DailyStepModel] {
        switch fetchOneWeekStepDataResult {
        case .success(let value): return value
        case .failure(let error): throw error
        case .none: throw NSError(domain: "MockHealthManager", code: 1, userInfo: nil)
        }
    }

    func fetchOneMonthStepData() async throws -> [FitnessApp.DailyStepModel] {
        switch fetchOneMonthStepDataResult {
        case .success(let value): return value
        case .failure(let error): throw error
        case .none: throw NSError(domain: "MockHealthManager", code: 1, userInfo: nil)
        }
    }

    func fetchThreeMonthsStepData() async throws -> [FitnessApp.DailyStepModel] {
        switch fetchThreeMonthsStepDataResult {
        case .success(let value): return value
        case .failure(let error): throw error
        case .none: throw NSError(domain: "MockHealthManager", code: 1, userInfo: nil)
        }
    }

    func fetchYTDAndOneYearChartData() async throws -> FitnessApp.YearChartDataResult {
        switch fetchYTDAndOneYearChartDataResult {
        case .success(let value): return value
        case .failure(let error): throw error
        case .none: throw NSError(domain: "MockHealthManager", code: 1, userInfo: nil)
        }
    }

    func fetchTodaySleepHours() async throws -> Double {
        switch fetchTodaySleepHoursResult {
        case .success(let value): return value
        case .failure(let error): throw error
        case .none: throw NSError(domain: "MockHealthManager", code: 1, userInfo: nil)
        }
    }

    func fetchLatestHeartRate() async throws -> Double {
        switch fetchLatestHeartRateResult {
        case .success(let value): return value
        case .failure(let error): throw error
        case .none: throw NSError(domain: "MockHealthManager", code: 1, userInfo: nil)
        }
    }

    func fetchDailySteps(startDate: Date, completion: @escaping (Result<[FitnessApp.DailyStepModel], Error>) -> Void) {
        completion(.failure(NSError(domain: "MockHealthManager", code: 1, userInfo: nil)))
    }

    func fetchYTDAndOneYearChartData(completion: @escaping (Result<FitnessApp.YearChartDataResult, Error>) -> Void) {
        completion(.failure(NSError(domain: "MockHealthManager", code: 1, userInfo: nil)))
    }

    func fetchCurrentWeekStepCount(completion: @escaping (Result<Double, Error>) -> Void) {
        completion(.failure(NSError(domain: "MockHealthManager", code: 1, userInfo: nil)))
    }
}
