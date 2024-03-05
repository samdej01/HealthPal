//
//  ChartsViewModel.swift
//  FitnessApp
//
//  Created by Jason Dubon on 8/9/23.
//

import Foundation

@Observable
final class ChartsViewModel {
    
    var selectedChart: ChartOptions = .oneWeek
    
    var oneWeekChartData = [DailyStepModel]()
    var oneWeekAverage = 0
    var oneWeekTotal = 0
    
    var oneMonthChartData = [DailyStepModel]()
    var oneMonthAverage = 0
    var oneMonthTotal = 0
    
    var threeMonthsChartData = [DailyStepModel]()
    var threeMonthAverage = 0
    var threeMonthTotal = 0
    
    var ytdChartData = [MonthlyStepModel]()
    var ytdAverage = 0
    var ytdTotal = 0
    
    var oneYearChartData = [MonthlyStepModel]()
    var oneYearAverage = 0
    var oneYearTotal = 0
    
    var showAlert = false
    
    var healthManager = HealthManager.shared
    
    init(healthManager: HealthManagerType = HealthManager.shared) {
        Task {
            do {
                // Batch fetches all the health & chart data
                async let oneWeek: () = try await fetchOneWeekStepData()
                async let oneMonth: () = try await fetchOneMonthStepData()
                async let threeMonths: () = try await fetchThreeMonthsStepData()
                async let ytdAndOneYear: () = try await fetchYTDAndOneYearChartData()
                
                _ = (try await oneWeek, try await oneMonth, try await threeMonths, try await ytdAndOneYear)
            } catch {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.showAlert = true
                }
            }
        }
    }
    
    func mockChartDataFor(days: Int) -> [DailyStepModel] {
        var mockData = [DailyStepModel]()
        for day in 0..<days {
            let currentDate = Calendar.current.date(byAdding: .day, value: -day, to: Date()) ?? Date()
            // Generating a random step count between 5000 and 15000
            let randomStepCount = Int.random(in: 500...15000)
            let dailyStepData = DailyStepModel(date: currentDate, count: randomStepCount)
            mockData.append(dailyStepData)
        }
        return mockData
    }
    
    func calculateAverageAndTotalFromData(steps: [DailyStepModel]) -> (Int, Int) {
        let total = steps.reduce(0, { $0 + $1.count })
        let average = total / steps.count
        
        return (total, average)
    }
    
    func fetchOneWeekStepData() async throws {
        try await withCheckedThrowingContinuation({ continuation in
            healthManager.fetchDailySteps(startDate: .oneWeekAgo) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let steps):
                    DispatchQueue.main.async { 
                        self.oneWeekChartData = steps
                        
                        (self.oneWeekTotal, self.oneWeekAverage) = self.calculateAverageAndTotalFromData(steps: steps)
                        continuation.resume()
                    }
                case .failure(let failure):
                    continuation.resume(throwing: failure)
                }
            }
        }) as Void
    }
    
    func fetchOneMonthStepData() async throws {
        try await withCheckedThrowingContinuation({ continuation in
            healthManager.fetchDailySteps(startDate: .oneMonthAgo) {  [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let steps):
                    DispatchQueue.main.async {
                        self.oneMonthChartData = steps
                        
                        (self.oneMonthTotal, self.oneMonthAverage) = self.calculateAverageAndTotalFromData(steps: steps)
                        continuation.resume()
                    }
                case .failure(let failure):
                    continuation.resume(throwing: failure)
                }
            }
        }) as Void
    }
    
    func fetchThreeMonthsStepData() async throws {
        try await withCheckedThrowingContinuation({ continuation in
            healthManager.fetchDailySteps(startDate: .threeMonthsAgo) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let steps):
                    DispatchQueue.main.async {
                        self.threeMonthsChartData = steps
                        
                        (self.threeMonthTotal, self.threeMonthAverage) = self.calculateAverageAndTotalFromData(steps: steps)
                        continuation.resume()
                    }
                case .failure(let failure):
                    continuation.resume(throwing: failure)
                }
            }
        }) as Void
    }
    
    /// Fetches both one year and year to date data in one pass
    func fetchYTDAndOneYearChartData() async throws {
        try await healthManager.requestHealthKitAccess()
        try await withCheckedThrowingContinuation({ continuation in
            healthManager.fetchYTDAndOneYearChartData { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let result):
                    DispatchQueue.main.async {
                        self.ytdChartData = result.ytd
                        self.oneYearChartData = result.oneYear
                        
                        self.ytdTotal = self.ytdChartData.reduce(0, { $0 + $1.count })
                        self.oneYearTotal = self.oneYearChartData.reduce(0, { $0 + $1.count })
                        
                        self.ytdAverage = self.ytdTotal / Calendar.current.component(.month, from: Date.now)
                        self.oneYearAverage = self.oneYearTotal / 12
                        
                        continuation.resume()
                    }
                case .failure(let failure):
                    continuation.resume(throwing: failure)
                }
            }
        }) as Void
    }
}
