//
//  GoalsViewModel.swift
//  FitnessApp
//
//  Created by Unicorn Semi on 16/01/2025.
//


import Foundation

class GoalsViewModel: ObservableObject {
    @Published var userGoal: Goal
    
    init() {
        // Initialize with default goal values
        userGoal = Goal(goalType: "Weight Loss", targetWeight: 70.0, workoutPreference: "Cardio", dailyCalorieIntake: 2000)
    }
    
    func updateGoal(goalType: String, targetWeight: Double?, workoutPreference: String?, dailyCalorieIntake: Int?) {
        userGoal = Goal(goalType: goalType, targetWeight: targetWeight, workoutPreference: workoutPreference, dailyCalorieIntake: dailyCalorieIntake)
    }
}
