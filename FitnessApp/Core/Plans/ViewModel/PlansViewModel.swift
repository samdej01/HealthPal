import SwiftUI
import Combine

// MARK: - Weekly Schedule Models
struct GymPlan: Identifiable {
    let id = UUID()
    let day: String
    let exercises: [String]
}

struct MealPlan: Identifiable {
    let id = UUID()
    let day: String
    let meals: [String]
}

class PlansViewModel: ObservableObject {
    @Published var gymSchedule: [GymPlan] = []
    @Published var mealSchedule: [MealPlan] = []
    @Published var userGoal: String = "Weight Loss" // Dynamically set
    private let kMeansModel = KMeansModel()

    /// Initialize and generate plans based on the user's goal
    init() {
        generatePlans()
    }

    /// Generates personalized plans based on the user's fitness goal
    func generatePlans() {
        // Define goals and mock feature data for clustering
        let goals = ["Weight Loss", "Muscle Gain", "Maintenance"]
        let features = [
            [0.5, 0.2], // Weight Loss
            [0.8, 0.9], // Muscle Gain
            [0.6, 0.5]  // Maintenance
        ]

        // Identify the cluster corresponding to the user's goal
        let goalIndex = goals.firstIndex(of: userGoal) ?? 0
        kMeansModel.fit(data: features, k: goals.count)
        let cluster = kMeansModel.predict(features: features[goalIndex])

        // Update schedules based on the cluster
        switch cluster {
        case 0: // Weight Loss
            gymSchedule = [
                GymPlan(day: "Monday", exercises: ["Push-Ups: 3x15", "Squats: 3x12"]),
                GymPlan(day: "Tuesday", exercises: ["Jogging: 30 mins", "Plank: 3x60 sec"]),
                GymPlan(day: "Wednesday", exercises: ["Yoga Flow: 20 mins", "Lunges: 3x12"]),
                GymPlan(day: "Thursday", exercises: ["Cycling: 40 mins"]),
                GymPlan(day: "Friday", exercises: ["Burpees: 3x10", "Sit-Ups: 3x15"]),
                GymPlan(day: "Saturday", exercises: ["Stretching: 30 mins"]),
                GymPlan(day: "Sunday", exercises: ["Rest or Light Walk"])
            ]

            mealSchedule = [
                MealPlan(day: "Monday", meals: ["Breakfast: Greek Yogurt", "Lunch: Grilled Chicken Salad", "Dinner: Steamed Fish"]),
                MealPlan(day: "Tuesday", meals: ["Breakfast: Oatmeal", "Lunch: Turkey Wrap", "Dinner: Grilled Salmon"]),
                MealPlan(day: "Wednesday", meals: ["Breakfast: Smoothie Bowl", "Lunch: Quinoa Salad", "Dinner: Stir-Fried Veggies"]),
                MealPlan(day: "Thursday", meals: ["Breakfast: Avocado Toast", "Lunch: Tuna Salad", "Dinner: Baked Cod"]),
                MealPlan(day: "Friday", meals: ["Breakfast: Scrambled Eggs", "Lunch: Chicken Caesar Salad", "Dinner: Grilled Shrimp"]),
                MealPlan(day: "Saturday", meals: ["Breakfast: Protein Pancakes", "Lunch: Veggie Wrap", "Dinner: Herb-Roasted Chicken"]),
                MealPlan(day: "Sunday", meals: ["Breakfast: Fruit Salad", "Lunch: Lentil Soup", "Dinner: Grilled Turkey"])
            ]

        case 1: // Muscle Gain
            gymSchedule = [
                GymPlan(day: "Monday", exercises: ["Deadlifts: 3x10", "Bench Press: 3x12"]),
                // More muscle-building exercises...
            ]

            mealSchedule = [
                MealPlan(day: "Monday", meals: ["Breakfast: Protein Shake", "Lunch: Grilled Steak", "Dinner: Pasta with Chicken"]),
                // More calorie-dense meals...
            ]

        case 2: // Maintenance
            gymSchedule = [
                GymPlan(day: "Monday", exercises: ["Jogging: 20 mins", "Plank: 3x60 sec"]),
                // More balanced exercises...
            ]

            mealSchedule = [
                MealPlan(day: "Monday", meals: ["Breakfast: Smoothie Bowl", "Lunch: Quinoa Salad", "Dinner: Grilled Salmon"]),
                // More balanced meals...
            ]

        default:
            break
        }
    }
}
