//
//  GoalEditorView.swift
//  FitnessApp
//
//  Created by Unicorn Semi on 16/01/2025.
//


import SwiftUI

struct GoalEditorView: View {
    @ObservedObject var viewModel: GoalsViewModel
    @State private var goalType = ""
    @State private var targetWeight: String = ""
    @State private var workoutPreference = ""
    @State private var dailyCalorieIntake: String = ""
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Goal Details")) {
                    TextField("Goal Type", text: $goalType)
                    TextField("Target Weight (kg)", text: $targetWeight)
                        .keyboardType(.decimalPad)
                    TextField("Workout Preference", text: $workoutPreference)
                    TextField("Daily Calorie Intake (kcal)", text: $dailyCalorieIntake)
                        .keyboardType(.numberPad)
                }
            }
            .navigationTitle("Edit Goals")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveGoal()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func saveGoal() {
        guard let weight = Double(targetWeight),
              let calorieIntake = Int(dailyCalorieIntake) else { return }
        
        viewModel.updateGoal(
            goalType: goalType,
            targetWeight: weight,
            workoutPreference: workoutPreference,
            dailyCalorieIntake: calorieIntake
        )
        dismiss()
    }
}
