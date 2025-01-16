import SwiftUI

struct PlansView: View {
    @StateObject var viewModel = PlansViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // User Goals Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Your Fitness Goals")
                            .font(.title2)
                            .bold()

                        Text("Step Count Goal: \(viewModel.stepGoal)")
                        Text("Calorie Goal: \(viewModel.caloriesGoal)")
                        Text("Active Minutes: \(viewModel.activeGoal)")
                        Text("Stand Hours: \(viewModel.standGoal)")
                        Text("Sleep Goal: \(viewModel.sleepGoal) hours/night")
                        Text("Weight Goal: \(viewModel.weightGoal) kg")
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)

                    // Meal Plans Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Meal Plans")
                            .font(.title2)
                            .bold()

                        ForEach(viewModel.mealPlans, id: \.id) { plan in
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

                        ForEach(viewModel.gymPlans, id: \.id) { plan in
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
        }
    }
}
