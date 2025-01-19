import SwiftUI
import RevenueCatUI

struct HomeView: View {
    @EnvironmentObject var tabState: FitnessTabState // Use @EnvironmentObject for ObservableObject
    @StateObject var viewModel = HomeViewModel() // ViewModel for managing the data
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    // Metrics Section
                    HStack {
                        Spacer()
                        
                        VStack(alignment: .leading) {
                            MetricView(title: "Calories", value: viewModel.calories, color: .red)
                            MetricView(title: "Active", value: viewModel.exercise, color: .green)
                            MetricView(title: "Stand", value: viewModel.stand, color: .blue)
                        }
                        
                        Spacer()
                        
                        ZStack {
                            ProgressCircleView(progress: $viewModel.calories, goal: viewModel.caloriesGoal, color: .red)
                            ProgressCircleView(progress: $viewModel.exercise, goal: viewModel.activeGoal, color: .green)
                                .padding(20)
                            ProgressCircleView(progress: $viewModel.stand, goal: viewModel.standGoal, color: .blue)
                                .padding(40)
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                    }
                    .padding()
                    
                    // Fitness Activity Section
                    Text("Fitness Activity")
                        .font(.title2)
                        .padding(.horizontal)
                    
                    if !viewModel.activities.isEmpty {
                        LazyVGrid(columns: Array(repeating: GridItem(spacing: 20), count: 2)) {
                            // Display Calories Burned first
                            if let caloriesActivity = viewModel.activities.first(where: { $0.title == "Calories Burned" }) {
                                ActivityCard(activity: caloriesActivity)
                            }
                            
                            // Display Sleep activity next
                            if let sleepActivity = viewModel.activities.first(where: { $0.title == "Sleep" }) {
                                ActivityCard(activity: sleepActivity)
                            }
                            
                            // Display Heart Rate activity next
                            if let heartRateActivity = viewModel.activities.first(where: { $0.title == "Heart Rate" }) {
                                ActivityCard(activity: heartRateActivity)
                            }
                            
                            // Display the remaining activities except Calories Burned, Sleep, and Heart Rate
                            ForEach(viewModel.activities.filter {
                                $0.title != "Calories Burned" &&
                                $0.title != "Sleep" &&
                                $0.title != "Heart Rate"
                            }, id: \.title) { activity in
                                ActivityCard(activity: activity)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .navigationTitle(FitnessTabs.home.rawValue)
            }
        }
        .alert("Oops", isPresented: $viewModel.showAlert) {
            Button("Ok") {
                viewModel.showAlert = false
            }
        } message: {
            Text("There was an issue fetching some of your data. Some health tracking requires an Apple Watch.")
        }
        .sheet(isPresented: $viewModel.showPaywall) {
            PaywallView()
        }
        .onAppear {
            viewModel.fetchGoalData()
        }
    }
}

// MARK: - Helper Views

/// Reusable metric display for health data
struct MetricView: View {
    let title: String
    let value: Int
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.callout)
                .bold()
                .foregroundColor(color)
            Text("\(value)")
                .bold()
        }
        .padding(.bottom)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(FitnessTabState()) // Ensure FitnessTabState is provided for the preview
    }
}
