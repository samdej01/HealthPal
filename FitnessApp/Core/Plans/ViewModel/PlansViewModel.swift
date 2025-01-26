import Foundation
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
        let goals = ["Weight Loss", "Muscle Gain", "Maintenance", "Cardio Endurance", "Flexibility & Mobility"]
        let features = [
            [0.5, 0.2, 0.8],  // Weight Loss: Low calories, moderate intensity, high cardio
            [0.9, 0.8, 0.3],  // Muscle Gain: High calories, high intensity, low cardio
            [0.6, 0.5, 0.5],  // Maintenance: Balanced
            [0.3, 0.1, 0.9],  // Cardio Endurance: High cardio, low intensity
            [0.4, 0.3, 0.7]   // Flexibility & Mobility: Moderate cardio, moderate flexibility
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
                GymPlan(day: "Monday", exercises: ["Deadlifts: 3x10", "Bench Press: 3x12", "Pull-Ups: 3x8"]),
                GymPlan(day: "Tuesday", exercises: ["Squats: 3x12", "Overhead Press: 3x10"]),
                GymPlan(day: "Wednesday", exercises: ["Rest or Light Mobility Work"]),
                GymPlan(day: "Thursday", exercises: ["Incline Bench Press: 3x10", "Lunges: 3x12"]),
                GymPlan(day: "Friday", exercises: ["Barbell Rows: 3x10", "Bicep Curls: 3x12"]),
                GymPlan(day: "Saturday", exercises: ["Deadlifts: 3x8", "Push-Ups: 3x15"]),
                GymPlan(day: "Sunday", exercises: ["Stretching and Foam Rolling"])
            ]
            mealSchedule = [
                MealPlan(day: "Monday", meals: ["Breakfast: Protein Shake", "Lunch: Grilled Steak", "Dinner: Pasta with Chicken"]),
                MealPlan(day: "Tuesday", meals: ["Breakfast: Eggs and Toast", "Lunch: Beef Stir Fry", "Dinner: Grilled Salmon"]),
                MealPlan(day: "Wednesday", meals: ["Breakfast: Peanut Butter Oatmeal", "Lunch: Tuna Wrap", "Dinner: Roasted Turkey"]),
                MealPlan(day: "Thursday", meals: ["Breakfast: Protein Pancakes", "Lunch: Chicken and Rice", "Dinner: Pork Chops"]),
                MealPlan(day: "Friday", meals: ["Breakfast: Fruit Smoothie", "Lunch: Turkey Sandwich", "Dinner: Grilled Steak"]),
                MealPlan(day: "Saturday", meals: ["Breakfast: Scrambled Eggs", "Lunch: Shrimp Salad", "Dinner: Pasta with Meat Sauce"]),
                MealPlan(day: "Sunday", meals: ["Breakfast: Pancakes", "Lunch: Chicken Caesar Salad", "Dinner: Grilled Lamb"])
            ]

        case 2: // Maintenance
            gymSchedule = [
                GymPlan(day: "Monday", exercises: ["Jogging: 20 mins", "Plank: 3x60 sec"]),
                GymPlan(day: "Tuesday", exercises: ["Cycling: 30 mins"]),
                GymPlan(day: "Wednesday", exercises: ["Light Yoga: 20 mins"]),
                GymPlan(day: "Thursday", exercises: ["Jogging: 20 mins", "Lunges: 3x12"]),
                GymPlan(day: "Friday", exercises: ["Push-Ups: 3x10"]),
                GymPlan(day: "Saturday", exercises: ["Stretching and Mobility Work"]),
                GymPlan(day: "Sunday", exercises: ["Rest"])
            ]
            mealSchedule = [
                MealPlan(day: "Monday", meals: ["Breakfast: Smoothie Bowl", "Lunch: Quinoa Salad", "Dinner: Grilled Salmon"]),
                MealPlan(day: "Tuesday", meals: ["Breakfast: Oatmeal", "Lunch: Turkey Wrap", "Dinner: Chicken Stir Fry"]),
                MealPlan(day: "Wednesday", meals: ["Breakfast: Greek Yogurt", "Lunch: Grilled Veggie Wrap", "Dinner: Baked Cod"]),
                MealPlan(day: "Thursday", meals: ["Breakfast: Fruit Salad", "Lunch: Lentil Soup", "Dinner: Grilled Chicken"]),
                MealPlan(day: "Friday", meals: ["Breakfast: Protein Bar", "Lunch: Tuna Sandwich", "Dinner: Beef Stir Fry"]),
                MealPlan(day: "Saturday", meals: ["Breakfast: Pancakes", "Lunch: Chicken Caesar Salad", "Dinner: Grilled Shrimp"]),
                MealPlan(day: "Sunday", meals: ["Breakfast: Avocado Toast", "Lunch: Turkey Wrap", "Dinner: Roasted Turkey"])
            ]

        case 3: // Cardio Endurance
            gymSchedule = [
                GymPlan(day: "Monday", exercises: ["Running: 30 mins"]),
                GymPlan(day: "Tuesday", exercises: ["Cycling: 40 mins"]),
                GymPlan(day: "Wednesday", exercises: ["Rowing Machine: 20 mins"]),
                GymPlan(day: "Thursday", exercises: ["Swimming: 30 mins"]),
                GymPlan(day: "Friday", exercises: ["Running: 30 mins"]),
                GymPlan(day: "Saturday", exercises: ["Cycling: 50 mins"]),
                GymPlan(day: "Sunday", exercises: ["Rest or Light Jog"])
            ]

            mealSchedule = [
                MealPlan(day: "Monday", meals: ["Breakfast: Fruit Smoothie", "Lunch: Tuna Salad", "Dinner: Baked Fish"]),
                MealPlan(day: "Tuesday", meals: ["Breakfast: Oatmeal", "Lunch: Turkey Sandwich", "Dinner: Grilled Chicken"]),
                MealPlan(day: "Wednesday", meals: ["Breakfast: Scrambled Eggs", "Lunch: Salad with Avocado", "Dinner: Salmon"]),
                MealPlan(day: "Thursday", meals: ["Breakfast: Yogurt with Nuts", "Lunch: Wrap with Veggies", "Dinner: Roasted Turkey"]),
                MealPlan(day: "Friday", meals: ["Breakfast: Pancakes", "Lunch: Shrimp Salad", "Dinner: Grilled Steak"]),
                MealPlan(day: "Saturday", meals: ["Breakfast: Protein Shake", "Lunch: Grilled Chicken", "Dinner: Fish Tacos"]),
                MealPlan(day: "Sunday", meals: ["Breakfast: Granola", "Lunch: Chicken Soup", "Dinner: Beef Stir Fry"])
            ]

        case 4: // Flexibility & Mobility
            gymSchedule = [
                GymPlan(day: "Monday", exercises: ["Dynamic Stretching: 20 mins"]),
                GymPlan(day: "Tuesday", exercises: ["Yoga: 30 mins"]),
                GymPlan(day: "Wednesday", exercises: ["Foam Rolling: 15 mins"]),
                GymPlan(day: "Thursday", exercises: ["Light Jog: 15 mins", "Stretching"]),
                GymPlan(day: "Friday", exercises: ["Balance Exercises: 20 mins"]),
                GymPlan(day: "Saturday", exercises: ["Pilates: 30 mins"]),
                GymPlan(day: "Sunday", exercises: ["Rest"])
            ]

            mealSchedule = [
                MealPlan(day: "Monday", meals: ["Breakfast: Oatmeal", "Lunch: Salad with Chickpeas", "Dinner: Grilled Veggies"]),
                MealPlan(day: "Tuesday", meals: ["Breakfast: Greek Yogurt", "Lunch: Tuna Wrap", "Dinner: Baked Fish"]),
                MealPlan(day: "Wednesday", meals: ["Breakfast: Smoothie Bowl", "Lunch: Lentil Soup", "Dinner: Stir-Fried Veggies"]),
                MealPlan(day: "Thursday", meals: ["Breakfast: Avocado Toast", "Lunch: Turkey Wrap", "Dinner: Grilled Salmon"]),
                MealPlan(day: "Friday", meals: ["Breakfast: Scrambled Eggs", "Lunch: Salad with Beans", "Dinner: Grilled Shrimp"]),
                MealPlan(day: "Saturday", meals: ["Breakfast: Pancakes", "Lunch: Veggie Burger", "Dinner: Grilled Chicken"]),
                MealPlan(day: "Sunday", meals: ["Breakfast: Granola", "Lunch: Salad", "Dinner: Roasted Turkey"])
            ]

        default:
            break
        }
    }
}
