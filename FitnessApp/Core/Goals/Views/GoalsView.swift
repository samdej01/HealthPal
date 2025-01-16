//
//  GoalsView.swift
//  FitnessApp
//
//  Created by Unicorn Semi on 16/01/2025.
//


import SwiftUI

struct GoalsView: View {
    @StateObject var viewModel = GoalsViewModel()
    @State private var showGoalEditor = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                // Display Current Goal
                Text("Your Fitness Goals")
                    .font(.title)
                    .bold()
                
                Text("Goal Type: \(viewModel.userGoal.goalType)")
                if let targetWeight = viewModel.userGoal.targetWeight {
                    Text("Target Weight: \(targetWeight, specifier: "%.1f") kg")
                }
                if let workoutPreference = viewModel.userGoal.workoutPreference {
                    Text("Workout Preference: \(workoutPreference)")
                }
                if let dailyCalories = viewModel.userGoal.dailyCalorieIntake {
                    Text("Daily Calorie Intake: \(dailyCalories) kcal")
                }
                
                Spacer()
                
                // Edit Goal Button
                Button(action: {
                    showGoalEditor.toggle()
                }) {
                    Text("Edit Goals")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
            .navigationTitle("Goals")
            .sheet(isPresented: $showGoalEditor) {
                GoalEditorView(viewModel: viewModel)
            }
        }
    }
}
