import SwiftUI

struct PlansView: View {
    @StateObject var viewModel = PlansViewModel()

    let columns = [GridItem(.flexible()), GridItem(.flexible())] // Two columns for even layout

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Weekly Gym Plan Section
                    Text("Workout Schedule")
                        .font(.title2)
                        .bold()
                        .padding(.horizontal)

                    LazyVGrid(columns: columns, spacing: 15) {
                        ForEach(viewModel.gymSchedule) { schedule in
                            VStack(alignment: .leading) {
                                Text(schedule.day)
                                    .font(.headline)
                                    .bold()
                                Divider()
                                ForEach(schedule.exercises, id: \.self) { exercise in
                                    Text(exercise)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)

                    // Weekly Meal Plan Section
                    Text("Meal Plans")
                        .font(.title2)
                        .bold()
                        .padding(.horizontal)

                    LazyVGrid(columns: columns, spacing: 15) {
                        ForEach(viewModel.mealSchedule) { schedule in
                            VStack(alignment: .leading) {
                                Text(schedule.day)
                                    .font(.headline)
                                    .bold()
                            Divider()
                                ForEach(schedule.meals, id: \.self) { meal in
                                Text(meal)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .padding(.bottom, meal == schedule.meals.last ? 0 : 10) // Add spacing except after dinner
                                }
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("Personalized Plans")
        }
    }
}
