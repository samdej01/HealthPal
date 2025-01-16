import SwiftUI

struct EditGoalsView: View {
    @EnvironmentObject var viewModel: ProfileViewModel

    var body: some View {
        NavigationStack {
            Form {
                // Step Goal
                Stepper("Step Count: \(viewModel.stepGoal)", value: $viewModel.stepGoal, step: 100)

                // Calories Goal
                Stepper("Calories: \(viewModel.caloriesGoal)", value: $viewModel.caloriesGoal, step: 50)

                // Active Time Goal
                Stepper("Active Time (min): \(viewModel.activeGoal)", value: $viewModel.activeGoal, step: 5)

                // Stand Hours Goal
                Stepper("Stand Hours: \(viewModel.standGoal)", value: $viewModel.standGoal, step: 1)

                // Sleep Goal
                Stepper("Sleep Hours: \(viewModel.sleepGoal)", value: $viewModel.sleepGoal, step: 1)

                // Weight Goal
                Stepper("Weight Goal: \(String(format: "%.1f", viewModel.weightGoal)) kg", value: $viewModel.weightGoal, step: 0.5)

                Button("Save Goals") {
                    viewModel.saveUserGoals()
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .navigationTitle("Edit Goals")
        }
    }
}
