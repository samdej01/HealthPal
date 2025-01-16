import Foundation

class PlansViewModel: ObservableObject {
    // Existing goals
    @Published var stepGoal: Int = 10000
    @Published var caloriesGoal: Int = 2000
    @Published var activeGoal: Int = 30
    @Published var standGoal: Int = 12

    // New goals
    @Published var sleepGoal: Int = 8 // Default 8 hours of sleep
    @Published var weightGoal: Int = 70 // Default weight target in kg

    // Meal Plans
    @Published var mealPlans: [Plan] = [
        Plan(title: "Low Carb Plan", description: "A diet focused on reducing carbohydrate intake."),
        Plan(title: "Keto Plan", description: "A high-fat, low-carb diet.")
    ]
    
    // Gym Plans
    @Published var gymPlans: [Plan] = [
        Plan(title: "Strength Training", description: "A workout plan for building muscle."),
        Plan(title: "Cardio Blast", description: "A high-intensity plan for endurance.")
    ]
}

struct Plan: Identifiable {
    let id = UUID()
    let title: String
    let description: String
}
