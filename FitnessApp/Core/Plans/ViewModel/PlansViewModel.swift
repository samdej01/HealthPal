import Foundation

struct FitnessGoal {
    var goalType: String // e.g., "Weight Loss", "Increase Strength"
    var targetWeight: Double? // Target weight for weight loss
    var workoutPreference: String? // e.g., "Cardio", "Strength Training"
    var dailyCalorieIntake: Int? // Suggested calorie intake
}

struct Plan {
    var title: String
    var description: String
}

class PlansViewModel: ObservableObject {
    @Published var userGoals: FitnessGoal = FitnessGoal(goalType: "Weight Loss", targetWeight: 70, workoutPreference: "Cardio", dailyCalorieIntake: 1800)
    @Published var mealPlans: [Plan] = []
    @Published var gymPlans: [Plan] = []
    
    func generatePlans() {
        // AI logic for generating meal and gym plans based on userGoals
        mealPlans = [
            Plan(title: "Breakfast", description: "Oatmeal with berries and almond milk"),
            Plan(title: "Lunch", description: "Grilled chicken salad with olive oil dressing"),
            Plan(title: "Dinner", description: "Steamed salmon with quinoa and broccoli")
        ]
        
        gymPlans = [
            Plan(title: "Day 1: Cardio", description: "30 minutes running, 15 minutes cycling"),
            Plan(title: "Day 2: Strength", description: "Full-body weight training routine"),
            Plan(title: "Day 3: Active Recovery", description: "Yoga or light stretching")
        ]
    }
    
    func updateUserGoal(goalType: String, targetWeight: Double?, workoutPreference: String?, dailyCalorieIntake: Int?) {
        userGoals = FitnessGoal(
            goalType: goalType,
            targetWeight: targetWeight,
            workoutPreference: workoutPreference,
            dailyCalorieIntake: dailyCalorieIntake
        )
        generatePlans() // Regenerate plans when goals change
    }
}
