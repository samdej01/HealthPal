import SwiftUI

struct PlansView: View {
    @StateObject var viewModel = PlansViewModel()
    @State private var showGoalEditor = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Display User Goals
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Your Fitness Goals")
                            .font(.title2)
                            .bold()
                        
                        Text("Goal Type: \(viewModel.userGoals.goalType)")
                        if let targetWeight = viewModel.userGoals.targetWeight {
                            Text("Target Weight: \(targetWeight) kg")
                        }
                        if let workoutPreference = viewModel.userGoals.workoutPreference {
                            Text("Workout Preference: \(workoutPreference)")
                        }
                        if let calorieIntake = viewModel.userGoals.dailyCalorieIntake {
                            Text("Daily Calorie Intake: \(calorieIntake) kcal")
                        }
                        
                        Button("Edit Goals") {
                            showGoalEditor = true
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    
                    // Meal Plans Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Meal Plans")
                            .font(.title2)
                            .bold()
                        
                        ForEach(viewModel.mealPlans, id: \.title) { plan in
                            VStack(alignment: .leading) {
                                Text(plan.title)
                                    .font(.headline)
                                Text(plan.description)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 5)
                        }
                    }
                    .padding()
                    
                    // Gym Plans Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Gym Plans")
                            .font(.title2)
                            .bold()
                        
                        ForEach(viewModel.gymPlans, id: \.title) { plan in
                            VStack(alignment: .leading) {
                                Text(plan.title)
                                    .font(.headline)
                                Text(plan.description)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 5)
                        }
                    }
                    .padding()
                }
                .padding(.horizontal)
            }
            .navigationTitle("Personalized Plans")
            .onAppear {
                viewModel.generatePlans()
            }
            .sheet(isPresented: $showGoalEditor) {
                GoalEditorView(viewModel: viewModel)
            }
        }
    }
}

struct GoalEditorView: View {
    @ObservedObject var viewModel: PlansViewModel
    @State private var goalType = ""
    @State private var targetWeight: String = ""
    @State private var workoutPreference = ""
    @State private var dailyCalorieIntake: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Edit Fitness Goals")) {
                    TextField("Goal Type (e.g., Weight Loss)", text: $goalType)
                    TextField("Target Weight (kg)", text: $targetWeight)
                        .keyboardType(.decimalPad)
                    TextField("Workout Preference (e.g., Cardio)", text: $workoutPreference)
                    TextField("Daily Calorie Intake (kcal)", text: $dailyCalorieIntake)
                        .keyboardType(.numberPad)
                }
            }
            .navigationTitle("Edit Goals")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        viewModel.updateUserGoal(
                            goalType: goalType.isEmpty ? viewModel.userGoals.goalType : goalType,
                            targetWeight: Double(targetWeight),
                            workoutPreference: workoutPreference.isEmpty ? viewModel.userGoals.workoutPreference : workoutPreference,
                            dailyCalorieIntake: Int(dailyCalorieIntake)
                        )
                    }
                }
            }
        }
    }
}
