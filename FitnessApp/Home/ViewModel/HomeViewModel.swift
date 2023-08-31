//
//  HomeViewModel.swift
//  FitnessApp
//
//  Created by Jason Dubon on 7/31/23.
//

import Foundation

class HomeViewModel: ObservableObject {
    
    let healthManager = HealthManager.shared
    
    @Published var calories: Int = 0
    @Published var exercise: Int = 0
    @Published var stand: Int = 0
    
    @Published var activities = [Activity]()
    @Published var workouts = [Workout]()
    
    var mockActivites = [
        Activity(title: "Today steps", subtitle: "Goal 12,000", image: "figure.walk", tintColor: .green, amount: "9,812"),
        Activity(title: "Today", subtitle: "Goal 1,000", image: "figure.walk", tintColor: .red, amount: "812"),
        Activity(title: "Today steps", subtitle: "Goal 12,000", image: "figure.walk", tintColor: .blue, amount: "9,812"),
        Activity(title: "Today steps", subtitle: "Goal 50,000", image: "figure.run", tintColor: .purple, amount: "55,812"),
    ]
    
    var mockWorkouts = [
        Workout(id: 0, title: "Running", image: "figure.run", tintColor: .cyan, duration: "51 mins", date: "Aug 1", calories: "512 kcal"),
        Workout(id: 1, title: "Strength Training", image: "figure.run", tintColor: .red, duration: "51 mins", date: "Aug 1", calories: "512 kcal"),
        Workout(id: 2, title: "Walk", image: "figure.walk", tintColor: .purple, duration: "5 mins", date: "Aug 11", calories: "512 kcal"),
        Workout(id: 3, title: "Running", image: "figure.run", tintColor: .cyan, duration: "1 mins", date: "Aug 19", calories: "512 kcal"),
        
    ]
    
    enum HomeViewModelError: String, Error {
        case failedToFetchTodayCalories = "Today's Calories"
        case failedToFetchTodayExercise = "Today's Exercise Time"
        case failedToFetchTodayStandHours = "Today's Stand Hours"
        case failedToFetchTodayStepCount = "Today's Step Count"
        case failedToFetchCurrentWeekActivities = "This Weeks Workouts"
        case failedToFetchRecentWorkouts = "Recent Workouts"
    }
    
    @Published var presentError = false
    @Published var error = "Unable to access your health data, please try again."
    var errors = [HomeViewModelError]()
    
    init() {
        Task {
            do {
                try await healthManager.requestHealthKitAccess()
                fetchTodayCalories()
                fetchTodayExerciseTime()
                fetchTodayStandHours()
                fetchTodaysSteps()
                fetchCurrentWeekActivities()
                fetchRecentWorkouts()
                handleErrors()
            } catch {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.error = "Unable to access your health data. Please make sure you give us access in order to enjoy the benefits of our application."
                    self.presentError = true
                }
            }
        }
        
    }
    
    func handleErrors() {
        if errors.count == 1, let newError = errors.first {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch newError {
                case .failedToFetchTodayCalories:
                    self.error = "Unable to fetch today's calories please make sure your device is setup correctly and try again. Calorie tracking requires an Apple Watch."
                case .failedToFetchTodayExercise:
                    self.error = "Unable to fetch today's exercise time please make sure your device is setup correctly and try again. Exercise time tracking requires an Apple Watch."
                case .failedToFetchTodayStandHours:
                    self.error = "Unable to fetch today's stand hours please make sure your device is setup correctly and try again. Stand hours tracking requires an Apple Watch."
                case .failedToFetchTodayStepCount:
                    self.error = "Unable to fetch today's total step count please make sure your device is setup correctly and try again."
                case .failedToFetchCurrentWeekActivities:
                    self.error = "Unable to fetch your workouts for the current week please make sure your device is setup correctly and try again."
                case .failedToFetchRecentWorkouts:
                    self.error = "Unable to fetch your workouts for your recent workouts please make sure your device is setup correctly and try again."
                }
                self.presentError = true
            }
        } else if errors.count > 1 {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.error = "Unable to fetch the following health data: \n\(self.errors.map({ $0.rawValue }).joined(separator: "\n")) \nPlease make sure your device & data are setup correctly and try again. Some health tracking requires an Apple Watch."
                self.presentError = true
            }
        }
    }
    
    func fetchTodayCalories() {
        healthManager.fetchTodayCaloriesBurned { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let calories):
                DispatchQueue.main.async {
                    self.calories = Int(calories)
                    let activity = Activity(title: "Calories Burned", subtitle: "today", image: "flame", tintColor: .red, amount: calories.formattedNumberString())
                    self.activities.append(activity)
                }
            case .failure(_):
                self.errors.append(HomeViewModelError.failedToFetchTodayCalories)
            }
        }
    }
    
    func fetchTodayExerciseTime() {
        healthManager.fetchTodayExerciseTime { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let exercise):
                DispatchQueue.main.async {
                    self.exercise = Int(exercise)
                }
            case .failure(_):
                self.errors.append(HomeViewModelError.failedToFetchTodayExercise)
            }
        }
    }
    
    func fetchTodayStandHours() {
        healthManager.fetchTodayStandHours { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let hours):
                DispatchQueue.main.async {
                    self.stand = hours
                }
            case .failure(_):
                self.errors.append(HomeViewModelError.failedToFetchTodayStandHours)
            }
        }
    }
    
    // MARK: Fitness Activity
    func fetchTodaysSteps() {
        healthManager.fetchTodaySteps { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let activity):
                DispatchQueue.main.async {
                    self.activities.append(activity)
                }
            case .failure(_):
                self.errors.append(HomeViewModelError.failedToFetchTodayStepCount)
            }
        }
    }
    
    func fetchCurrentWeekActivities() {
        healthManager.fetchCurrentWeekWorkoutStats { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let activities):
                DispatchQueue.main.async {
                    self.activities.append(contentsOf: activities)
                }
            case .failure(_):
                self.errors.append(HomeViewModelError.failedToFetchCurrentWeekActivities)
            }
        }
    }
    
    // MARK: Recent Workouts
    func fetchRecentWorkouts() {
        healthManager.fetchWorkoutsForMonth(month: Date()) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let workouts):
                DispatchQueue.main.async {
                    self.workouts = Array(workouts.prefix(4))
                }
            case .failure(_):
                self.errors.append(HomeViewModelError.failedToFetchRecentWorkouts)
            }
        }
    }
}
