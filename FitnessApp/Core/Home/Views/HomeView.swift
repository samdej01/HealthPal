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
                    SectionHeader(title: "Fitness Activity") {
                        if tabState.isPremium {
                            viewModel.showAllActivities.toggle()
                        } else {
                            viewModel.showPaywall = true
                        }
                    }
                    .padding(.horizontal)
                    
                    if !viewModel.activities.isEmpty {
                        LazyVGrid(columns: Array(repeating: GridItem(spacing: 20), count: 2)) {
                            ForEach(viewModel.activities.prefix(viewModel.showAllActivities ? 8 : 4), id: \.title) { activity in
                                ActivityCard(activity: activity)
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Recent Workouts Section
                    SectionHeader(title: "Recent Workouts") {
                        if tabState.isPremium {
                            NavigationLink {
                                MonthWorkoutsView()
                            } label: {
                                Text("Show more")
                                    .padding(.all, 10)
                                    .foregroundColor(.white)
                            }
                        } else {
                            viewModel.showPaywall = true
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    LazyVStack {
                        ForEach(viewModel.workouts, id: \.self) { workout in
                            WorkoutCard(workout: workout)
                        }
                    }
                    .padding(.bottom)
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

/// Section header with a customizable action button
struct SectionHeader: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        HStack {
            Text(title)
                .font(.title2)
            Spacer()
            ZStack {
                Color.green
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .frame(width: 115)
                Button(action: action) {
                    Text("Show more")
                        .padding(10)
                        .foregroundColor(.white)
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(FitnessTabState()) // Ensure FitnessTabState is provided for the preview
    }
}
