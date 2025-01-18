import SwiftUI

struct PlansView: View {
    @StateObject var viewModel = PlansViewModel()

    let columns = [GridItem(.flexible()), GridItem(.flexible())] // Two-column grid

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Workout Schedule Section
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
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)

                    // Meal Plans Section
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
                                }
                            }
                            .padding()
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
