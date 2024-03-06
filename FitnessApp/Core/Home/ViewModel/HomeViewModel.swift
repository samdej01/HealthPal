//
//  HomeViewModel.swift
//  FitnessApp
//
//  Created by Jason Dubon on 7/31/23.
//

import Foundation

@Observable
final class HomeViewModel {
    
    var showPaywall = false
    var showAllActivities = false
    
    var calories: Int = 0
    var exercise: Int = 0
    var stand: Int = 0
    
    var stepGoal: Int = UserDefaults.standard.value(forKey: "stepGoal") as? Int ?? 7500
    var caloriesGoal: Int = UserDefaults.standard.value(forKey: "caloriesGoal") as? Int ?? 900
    var activeGoal: Int = UserDefaults.standard.value(forKey: "activeGoal") as? Int ?? 60
    var standGoal: Int = UserDefaults.standard.value(forKey: "standGoal") as? Int ?? 12
    
    var activities = [Activity]()
    var workouts = [Workout]()
    
    var showAlert = false

    var healthManager: HealthManagerType
    
    init(healthManager: HealthManagerType = HealthManager.shared) {
        self.healthManager = healthManager
        Task {
            do {
                try await healthManager.requestHealthKitAccess()
                try await fetchHealthData()
            } catch {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.showAlert =  true
                }
            }
        }
    }
    
    func fetchHealthData() async throws {
        // Fetch all health data in parallel at init of View Model
        async let fetchCalories: () = try await fetchTodayCalories()
        async let fetchExercise: () = try await fetchTodayExerciseTime()
        async let fetchStand: () = try await fetchTodayStandHours()
        async let fetchSteps: () = try await fetchTodaySteps()
        async let fetchActivities: () = try await fetchCurrentWeekActivities()
        async let fetchWorkouts: () = try await fetchRecentWorkouts()
        
        let (_, _, _, _, _, _) = (try await fetchCalories, try await fetchExercise, try await fetchStand, try await fetchSteps, try await fetchActivities, try await fetchWorkouts)
    }
    
    func fetchGoalData() {
        stepGoal = UserDefaults.standard.value(forKey: "stepGoal") as? Int ?? 7500
        caloriesGoal = UserDefaults.standard.value(forKey: "caloriesGoal") as? Int ?? 900
        activeGoal = UserDefaults.standard.value(forKey: "activeGoal") as? Int ?? 60
        standGoal = UserDefaults.standard.value(forKey: "standGoal") as? Int ?? 12
    }
    
    /// Fetches today calories and leaves the activity card blank if it fails
    func fetchTodayCalories() async throws {
        try await withCheckedThrowingContinuation({ continuation in
            healthManager.fetchTodayCaloriesBurned { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let calories):
                    DispatchQueue.main.async {
                        self.calories = Int(calories)
                        let activity = Activity(title: "Calories Burned", subtitle: "today", image: "flame", tintColor: .red, amount: calories.formattedNumberString())
                        self.activities.append(activity)
                        continuation.resume()
                    }
                case .failure(let failure):
                    DispatchQueue.main.async {
                        let activity = Activity(title: "Calories Burned", subtitle: "today", image: "flame", tintColor: .red, amount: "---")
                        self.activities.append(activity)
                        continuation.resume(throwing: failure)
                    }
                }
            }
        }) as Void
    }
    
    func fetchTodayExerciseTime() async throws {
        try await withCheckedThrowingContinuation({ continuation in
            healthManager.fetchTodayExerciseTime { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let exercise):
                    DispatchQueue.main.async {
                        self.exercise = Int(exercise)
                        continuation.resume()
                    }
                case .failure(let failure):
                    continuation.resume(throwing: failure)
                }
            }
        }) as Void
    }
    
    func fetchTodayStandHours() async throws {
        try await withCheckedThrowingContinuation({ continuation in
            healthManager.fetchTodayStandHours { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let hours):
                    DispatchQueue.main.async {
                        self.stand = hours
                        continuation.resume()
                    }
                case .failure(let failure):
                    continuation.resume(throwing: failure)
                }
            }
        }) as Void
    }
    
    // MARK: Fitness Activity
    
    /// Fetches today's steps and displays an empty card if it fails
    func fetchTodaySteps() async throws {
        try await withCheckedThrowingContinuation({ continuation in
            healthManager.fetchTodaySteps { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let activity):
                    DispatchQueue.main.async {
                        self.activities.insert(activity, at: 0)
                        continuation.resume()
                    }
                case .failure(let failure):
                    DispatchQueue.main.async {
                        self.activities.append(Activity(title: "Today Steps", subtitle: "Goal: 800", image: "figure.walk", tintColor: .green, amount: "---"))
                        continuation.resume(throwing: failure)
                    }
                }
            }
        }) as Void
    }
    
    func fetchCurrentWeekActivities() async throws {
        try await withCheckedThrowingContinuation({ continuation in
            healthManager.fetchCurrentWeekWorkoutStats { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let activities):
                    DispatchQueue.main.async {
                        self.activities.append(contentsOf: activities)
                        continuation.resume()
                    }
                case .failure(let failure):
                    continuation.resume(throwing: failure)
                }
            }
        }) as Void
    }
    
    // MARK: Recent Workouts
    func fetchRecentWorkouts() async throws {
        try await withCheckedThrowingContinuation({ continuation in
            healthManager.fetchWorkoutsForMonth(month: Date()) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let workouts):
                    DispatchQueue.main.async {
                        // Only displays the most recent 4 (four) workouts, the rest are behind a paywall
                        self.workouts = Array(workouts.prefix(4))
                        continuation.resume()
                    }
                case .failure(let failure):
                    continuation.resume(throwing: failure)
                }
            }
        }) as Void
    }
}
