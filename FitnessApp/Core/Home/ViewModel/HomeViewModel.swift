import Foundation

@Observable
final class HomeViewModel: ObservableObject {
    
    var showPaywall = false
    var showAllActivities = false
    
    var calories: Int = 0
    var exercise: Int = 0
    var stand: Int = 0
    var sleepHours: Double = 0.0
    var heartRate: Double = 0.0

    
    var stepGoal: Int = UserDefaults.standard.value(forKey: "stepGoal") as? Int ?? 7500
    var caloriesGoal: Int = UserDefaults.standard.value(forKey: "caloriesGoal") as? Int ?? 900
    var activeGoal: Int = UserDefaults.standard.value(forKey: "activeGoal") as? Int ?? 60
    var standGoal: Int = UserDefaults.standard.value(forKey: "standGoal") as? Int ?? 12
    
    var activities = [Activity]()
    var workouts = [Workout]()
    
    var showAlert = false

    var healthManager: HealthManagerType
    
    init(healthManager: HealthManagerType = HealthManager.shared) {
        self.healthManager = healthManager
        Task {
            do {
                try await healthManager.requestHealthKitAccess()
                try await fetchHealthData()
            } catch {
                await MainActor.run {
                    showAlert = true
                }
            }
        }
    }
    
    @MainActor
    func fetchHealthData() async throws {
        async let fetchCalories: () = try await fetchTodayCalories()
        async let fetchExercise: () = try await fetchTodayExerciseTime()
        async let fetchStand: () = try await fetchTodayStandHours()
        async let fetchSteps: () = try await fetchTodaySteps()
        async let fetchActivities: () = try await fetchCurrentWeekActivities()
        async let fetchWorkouts: () = try await fetchRecentWorkouts()
        async let fetchSleep: () = try await fetchTodaySleep()
        async let fetchHeartRate: () = try await fetchTodayHeartRate()
        
        let (_, _, _, _, _, _, _, _) = (
            try await fetchCalories,
            try await fetchExercise,
            try await fetchStand,
            try await fetchSteps,
            try await fetchActivities,
            try await fetchWorkouts,
            try await fetchSleep,
            try await fetchHeartRate
        )
    }

    func fetchGoalData() {
        stepGoal = UserDefaults.standard.value(forKey: "stepGoal") as? Int ?? 7500
        caloriesGoal = UserDefaults.standard.value(forKey: "caloriesGoal") as? Int ?? 900
        activeGoal = UserDefaults.standard.value(forKey: "activeGoal") as? Int ?? 60
        standGoal = UserDefaults.standard.value(forKey: "standGoal") as? Int ?? 12
    }
    
    /// Fetches today calories and leaves the activity card blank if it fails
    func fetchTodayCalories() async throws {
        do {
            calories = Int(try await healthManager.fetchTodayCalories())
            let activity = Activity(title: "Calories Burned", subtitle: "today", image: "flame", tintColor: .red, amount: "\(calories)")
            activities.append(activity)
        } catch {
            let activity = Activity(title: "Calories Burned", subtitle: "today", image: "flame", tintColor: .red, amount: "---")
            activities.append(activity)
        }
    }
    
    func fetchTodayExerciseTime() async throws {
        exercise = Int(try await healthManager.fetchTodayExerciseTime())
    }
    
    func fetchTodayStandHours() async throws {
        stand = try await healthManager.fetchTodayStandHours()
    }
    
    // MARK: Fitness Activity
    
    /// Fetches today's steps and displays an empty card if it fails
    func fetchTodaySteps() async throws {
        let activity = try await healthManager.fetchTodaySteps()
        activities.insert(activity, at: 0)
    }
    
    func fetchCurrentWeekActivities() async throws {
        let weekActivities = try await healthManager.fetchCurrentWeekActivities()
        activities.append(contentsOf: weekActivities)
    }
    
    // MARK: Recent Workouts
    func fetchRecentWorkouts() async throws {
        let monthWorkouts = try await healthManager.fetchRecentWorkouts()
        // Only displays the most recent 4 (four) workouts, the rest are behind a paywall
        workouts = Array(monthWorkouts.prefix(4))
    }
    
    func fetchTodaySleep() async throws {
        do {
            sleepHours = try await healthManager.fetchTodaySleepHours()
            let activity = Activity(title: "Sleep", subtitle: "Today", image: "bed.double", tintColor: .purple, amount: "\(sleepHours.formatted(.number.precision(.fractionLength(1)))) hrs")
            activities.append(activity)
        } catch {
            let activity = Activity(title: "Sleep", subtitle: "Today", image: "bed.double", tintColor: .purple, amount: "---")
            activities.append(activity)
        }
    }

    func fetchTodayHeartRate() async throws {
        do {
            heartRate = try await healthManager.fetchLatestHeartRate()
            let activity = Activity(title: "Heart Rate", subtitle: "Today", image: "heart.fill", tintColor: .red, amount: "\(Int(heartRate)) bpm")
            activities.append(activity)
        } catch {
            let activity = Activity(title: "Heart Rate", subtitle: "Today", image: "heart.fill", tintColor: .red, amount: "---")
            activities.append(activity)
        }
    }

        
}
