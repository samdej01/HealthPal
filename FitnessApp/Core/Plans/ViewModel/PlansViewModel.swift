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
        let goals = [
            "Weight Loss", //1
            "Muscle Gain", //2
            "Maintenance", //3
            "Cardio Endurance", //4
            "Flexibility & Mobility", //5
            "Stress Management", //6
            "Sports Performance", //7
            "Rehabilitation & Recovery", //8
            "Beginner Fitness",//9
            "Advanced Fitness",//10
            "Senior Fitness",//11
            "Pregnancy Fitness",//12
            "High-Intensity Interval Training (HIIT)", //13
            "Low Impact Fitness", //14
            "Body Toning", //15
            "Endurance Training", //16
            "Vegan Nutrition", //17
            "Postpartum Fitness", //18
            "Core Strength", //19
            "Youth Fitness", //20
            "Pre-Diabetes Management", //21
            "Arthritis-Friendly Workouts", //22
            "Marathon Training", //23
            "Desk Job Fitness", //24
            "Sleep Improvement" //25
        ]
        let features = [
            //[calorie focus, workout intensity, and cardio]
            
            [0.5, 0.2, 0.8],  // Weight Loss 1
            [0.9, 0.8, 0.3],  // Muscle Gain 2
            [0.6, 0.5, 0.5],  // Maintenance 3
            [0.3, 0.1, 0.9],  // Cardio Endurance 4
            [0.4, 0.3, 0.7],  // Flexibility & Mobility 5
            [0.2, 0.1, 0.9],  // Stress Management 6
            [0.8, 0.9, 0.4],  // Sports Performance 7
            [0.3, 0.2, 0.6],  // Rehabilitation & Recovery 8
            [0.4, 0.3, 0.5],  // Beginner Fitness 9
            [0.7, 0.8, 0.5],  // Advanced Fitness 10
            [0.3, 0.4, 0.6],  // Senior Fitness 11
            [0.5, 0.1, 0.8],  // Pregnancy Fitness 12
            [0.7, 0.6, 0.9],  // High-Intensity Interval Training (HIIT) 13
            [0.2, 0.3, 0.6],  // Low Impact Fitness 14
            [0.4, 0.5, 0.7],  // Body Toning 15
            [0.6, 0.2, 0.9],  // Endurance Training 16
            [0.3, 0.5, 0.8],  // Vegan Nutrition 17
            [0.2, 0.2, 0.6],  // Postpartum Fitness 18
            [0.5, 0.6, 0.9],  // Core Strength 19
            [0.4, 0.5, 0.6],  // Youth Fitness 20
            [0.3, 0.3, 0.8],  // Pre-Diabetes Management 21
            [0.2, 0.4, 0.5],  // Arthritis-Friendly Workouts 22
            [0.7, 0.6, 0.7],  // Marathon Training 23
            [0.5, 0.4, 0.6],  // Desk Job Fitness 24
            [0.3, 0.2, 0.9]   // Sleep Improvement 25
        ]


        // Identify the cluster corresponding to the user's goal
        let goalIndex = goals.firstIndex(of: userGoal) ?? 0
        kMeansModel.fit(data: features, k: goals.count)
        let cluster = kMeansModel.predict(features: features[goalIndex])

        // Update schedules based on the cluster
        switch cluster {
        case 0: // Weight Loss 1
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

        case 1: // Muscle Gain 2
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

        case 2: // Maintenance 3
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

        case 3: // Cardio Endurance 4
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

        case 4: // Flexibility & Mobility 5
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
            
        case 5: // Stress Management 6
                    gymSchedule = [
                        GymPlan(day: "Monday", exercises: ["Yoga Flow (30 mins)", "Deep Breathing (10 mins)"]),
                        GymPlan(day: "Tuesday", exercises: ["Restorative Stretching (20 mins)"]),
                        GymPlan(day: "Wednesday", exercises: ["Light Jogging (15 mins)", "Meditation (15 mins)"]),
                        GymPlan(day: "Thursday", exercises: ["Pilates (30 mins)"]),
                        GymPlan(day: "Friday", exercises: ["Dynamic Stretching (20 mins)"]),
                        GymPlan(day: "Saturday", exercises: ["Hiking or Outdoor Walk (30 mins)"]),
                        GymPlan(day: "Sunday", exercises: ["Rest or Guided Meditation (20 mins)"])
                    ]
                    mealSchedule = [
                        MealPlan(day: "Monday", meals: ["Breakfast: Smoothie with Spinach and Banana", "Lunch: Grilled Salmon with Quinoa"]),
                        MealPlan(day: "Tuesday", meals: ["Breakfast: Oatmeal", "Lunch: Steamed Vegetables", "Dinner: Grilled Chicken"])
                    ]
            
        case 6: // Sports Performance 7
            gymSchedule = [
                GymPlan(day: "Monday", exercises: ["Agility Drills (20 mins)", "Strength Training (30 mins)"]),
                GymPlan(day: "Tuesday", exercises: ["Sprint Intervals (15 mins)", "Core Stability (20 mins)"]),
                GymPlan(day: "Wednesday", exercises: ["Rest or Light Recovery"]),
                GymPlan(day: "Thursday", exercises: ["Speed Work (20 mins)", "Dynamic Stretching"]),
                GymPlan(day: "Friday", exercises: ["Explosive Power Training (30 mins)", "Plyometrics (15 mins)"]),
                GymPlan(day: "Saturday", exercises: ["Game Simulation Practice"]),
                GymPlan(day: "Sunday", exercises: ["Active Recovery"])
            ]
            mealSchedule = [
                MealPlan(day: "Monday", meals: ["Breakfast: Protein Smoothie", "Lunch: Grilled Chicken Wrap", "Dinner: Quinoa Salad"]),
                MealPlan(day: "Tuesday", meals: ["Breakfast: Oatmeal with Nuts", "Lunch: Beef Stir Fry", "Dinner: Sweet Potato and Salmon"]),
                MealPlan(day: "Wednesday", meals: ["Breakfast: Scrambled Eggs and Avocado Toast", "Lunch: Chicken Salad", "Dinner: Pasta with Shrimp"])
            ]

        case 7: // Rehabilitation & Recovery 8
            gymSchedule = [
                GymPlan(day: "Monday", exercises: ["Stretching (20 mins)", "Low-Impact Yoga"]),
                GymPlan(day: "Tuesday", exercises: ["Pool Exercises (30 mins)"]),
                GymPlan(day: "Wednesday", exercises: ["Foam Rolling (15 mins)", "Balance Work"]),
                GymPlan(day: "Thursday", exercises: ["Resistance Band Workouts"]),
                GymPlan(day: "Friday", exercises: ["Gentle Core Exercises"]),
                GymPlan(day: "Saturday", exercises: ["Rest"]),
                GymPlan(day: "Sunday", exercises: ["Light Walking"])
            ]
            mealSchedule = [
                MealPlan(day: "Monday", meals: ["Breakfast: Greek Yogurt", "Lunch: Grilled Fish with Steamed Veggies", "Dinner: Chicken and Brown Rice"]),
                MealPlan(day: "Tuesday", meals: ["Breakfast: Smoothie Bowl", "Lunch: Tuna Wrap", "Dinner: Lentil Soup"]),
                MealPlan(day: "Wednesday", meals: ["Breakfast: Boiled Eggs", "Lunch: Salad with Chickpeas", "Dinner: Baked Sweet Potatoes"])
            ]

        case 8: // Beginner Fitness 9
            gymSchedule = [
                GymPlan(day: "Monday", exercises: ["Walk/Jog (20 mins)", "Bodyweight Squats (3x12)"]),
                GymPlan(day: "Tuesday", exercises: ["Light Yoga (15 mins)"]),
                GymPlan(day: "Wednesday", exercises: ["Plank (3x30 secs)", "Low-Impact Cardio"]),
                GymPlan(day: "Thursday", exercises: ["Stretching (20 mins)"]),
                GymPlan(day: "Friday", exercises: ["Walking (20 mins)", "Core Activation"]),
                GymPlan(day: "Saturday", exercises: ["Rest"]),
                GymPlan(day: "Sunday", exercises: ["Active Play or Recreation"])
            ]
            mealSchedule = [
                MealPlan(day: "Monday", meals: ["Breakfast: Avocado Toast", "Lunch: Grilled Chicken Salad", "Dinner: Steamed Veggies"]),
                MealPlan(day: "Tuesday", meals: ["Breakfast: Smoothie Bowl", "Lunch: Turkey Wrap", "Dinner: Baked Fish"]),
                MealPlan(day: "Wednesday", meals: ["Breakfast: Scrambled Eggs", "Lunch: Pasta Salad", "Dinner: Stir-Fried Vegetables"])
            ]

        case 9: // Advanced Fitness 10
            gymSchedule = [
                GymPlan(day: "Monday", exercises: ["Heavy Deadlifts (4x8)", "Overhead Press (4x10)", "Plank to Push-Up"]),
                GymPlan(day: "Tuesday", exercises: ["Interval Sprints (30 mins)", "Core Strength"]),
                GymPlan(day: "Wednesday", exercises: ["Active Recovery"]),
                GymPlan(day: "Thursday", exercises: ["Explosive Lifting (20 mins)", "Dynamic Mobility"]),
                GymPlan(day: "Friday", exercises: ["Power Circuit (40 mins)", "Plyometrics"]),
                GymPlan(day: "Saturday", exercises: ["Endurance Running"]),
                GymPlan(day: "Sunday", exercises: ["Stretching and Recovery"])
            ]
            mealSchedule = [
                MealPlan(day: "Monday", meals: ["Breakfast: High-Protein Smoothie", "Lunch: Steak and Quinoa", "Dinner: Grilled Salmon"]),
                MealPlan(day: "Tuesday", meals: ["Breakfast: Eggs with Spinach", "Lunch: Chicken Stir Fry", "Dinner: Beef Stew"]),
                MealPlan(day: "Wednesday", meals: ["Breakfast: Protein Pancakes", "Lunch: Turkey Wrap", "Dinner: Shrimp Pasta"])
            ]
            
        case 10: // Senior Fitness 11
                   gymSchedule = [
                       GymPlan(day: "Monday", exercises: ["Gentle Yoga (20 mins)", "Walking: 30 mins"]),
                       GymPlan(day: "Tuesday", exercises: ["Stretching and Balance Work"]),
                       GymPlan(day: "Wednesday", exercises: ["Low-Impact Aerobics"]),
                       GymPlan(day: "Thursday", exercises: ["Chair Exercises"]),
                       GymPlan(day: "Friday", exercises: ["Light Resistance Band Training"]),
                       GymPlan(day: "Saturday", exercises: ["Active Rest"]),
                       GymPlan(day: "Sunday", exercises: ["Outdoor Walk"])
                   ]
                   mealSchedule = [
                       MealPlan(day: "Monday", meals: ["Breakfast: Oatmeal", "Lunch: Grilled Fish", "Dinner: Steamed Vegetables"]),
                       MealPlan(day: "Tuesday", meals: ["Breakfast: Greek Yogurt", "Lunch: Lentil Soup", "Dinner: Quinoa Salad"]),
                       MealPlan(day: "Wednesday", meals: ["Breakfast: Smoothie Bowl", "Lunch: Chicken Salad", "Dinner: Steamed Sweet Potatoes"])
                   ]

               case 11: // Pregnancy Fitness 12
                   gymSchedule = [
                       GymPlan(day: "Monday", exercises: ["Prenatal Yoga (30 mins)"]),
                       GymPlan(day: "Tuesday", exercises: ["Walking: 20 mins"]),
                       GymPlan(day: "Wednesday", exercises: ["Stretching Exercises"]),
                       GymPlan(day: "Thursday", exercises: ["Light Resistance Training"]),
                       GymPlan(day: "Friday", exercises: ["Breathing and Relaxation"]),
                       GymPlan(day: "Saturday", exercises: ["Active Recovery"]),
                       GymPlan(day: "Sunday", exercises: ["Rest"])
                   ]
                   mealSchedule = [
                       MealPlan(day: "Monday", meals: ["Breakfast: Avocado Toast", "Lunch: Grilled Chicken Wrap", "Dinner: Salmon and Steamed Veggies"]),
                       MealPlan(day: "Tuesday", meals: ["Breakfast: Protein Pancakes", "Lunch: Turkey Wrap", "Dinner: Lentil Soup"]),
                       MealPlan(day: "Wednesday", meals: ["Breakfast: Scrambled Eggs", "Lunch: Tuna Salad", "Dinner: Grilled Shrimp"])
                   ]

               case 12: // High-Intensity Interval Training (HIIT) 13
                   gymSchedule = [
                       GymPlan(day: "Monday", exercises: ["HIIT Circuit: 30 mins"]),
                       GymPlan(day: "Tuesday", exercises: ["Active Rest or Stretching"]),
                       GymPlan(day: "Wednesday", exercises: ["HIIT Sprints: 20 mins"]),
                       GymPlan(day: "Thursday", exercises: ["Strength Training"]),
                       GymPlan(day: "Friday", exercises: ["HIIT Cardio: 30 mins"]),
                       GymPlan(day: "Saturday", exercises: ["Stretch and Recovery"]),
                       GymPlan(day: "Sunday", exercises: ["Rest"])
                   ]
                   mealSchedule = [
                       MealPlan(day: "Monday", meals: ["Breakfast: Smoothie Bowl", "Lunch: Grilled Chicken Salad", "Dinner: Baked Cod"]),
                       MealPlan(day: "Tuesday", meals: ["Breakfast: Scrambled Eggs", "Lunch: Tuna Wrap", "Dinner: Steamed Broccoli"]),
                       MealPlan(day: "Wednesday", meals: ["Breakfast: Greek Yogurt", "Lunch: Veggie Wrap", "Dinner: Grilled Steak"])
                   ]

               case 13: // Low Impact Fitness 14
                   gymSchedule = [
                       GymPlan(day: "Monday", exercises: ["Water Aerobics: 30 mins"]),
                       GymPlan(day: "Tuesday", exercises: ["Light Yoga"]),
                       GymPlan(day: "Wednesday", exercises: ["Stretching"]),
                       GymPlan(day: "Thursday", exercises: ["Balance Training"]),
                       GymPlan(day: "Friday", exercises: ["Walking: 40 mins"]),
                       GymPlan(day: "Saturday", exercises: ["Foam Rolling"]),
                       GymPlan(day: "Sunday", exercises: ["Rest"])
                   ]
                   mealSchedule = [
                       MealPlan(day: "Monday", meals: ["Breakfast: Fruit Salad", "Lunch: Quinoa Bowl", "Dinner: Grilled Fish"]),
                       MealPlan(day: "Tuesday", meals: ["Breakfast: Protein Pancakes", "Lunch: Turkey Salad", "Dinner: Roasted Vegetables"]),
                       MealPlan(day: "Wednesday", meals: ["Breakfast: Scrambled Eggs", "Lunch: Lentil Soup", "Dinner: Grilled Chicken"])
                   ]

               case 14: // Body Toning 15
                   gymSchedule = [
                       GymPlan(day: "Monday", exercises: ["Pilates: 30 mins"]),
                       GymPlan(day: "Tuesday", exercises: ["Resistance Band Training"]),
                       GymPlan(day: "Wednesday", exercises: ["Rest"]),
                       GymPlan(day: "Thursday", exercises: ["Yoga and Stretching"]),
                       GymPlan(day: "Friday", exercises: ["Light Dumbbell Work"]),
                       GymPlan(day: "Saturday", exercises: ["Foam Rolling"]),
                       GymPlan(day: "Sunday", exercises: ["Rest"])
                   ]
                   mealSchedule = [
                       MealPlan(day: "Monday", meals: ["Breakfast: Protein Smoothie", "Lunch: Chicken Salad", "Dinner: Baked Salmon"]),
                       MealPlan(day: "Tuesday", meals: ["Breakfast: Avocado Toast", "Lunch: Tuna Wrap", "Dinner: Grilled Vegetables"]),
                       MealPlan(day: "Wednesday", meals: ["Breakfast: Pancakes", "Lunch: Veggie Salad", "Dinner: Lentil Soup"])
                   ]

               case 15: // Endurance Training 16
                   gymSchedule = [
                       GymPlan(day: "Monday", exercises: ["Running: 40 mins"]),
                       GymPlan(day: "Tuesday", exercises: ["Cycling"]),
                       GymPlan(day: "Wednesday", exercises: ["Rest"]),
                       GymPlan(day: "Thursday", exercises: ["Swimming"]),
                       GymPlan(day: "Friday", exercises: ["Running: 50 mins"]),
                       GymPlan(day: "Saturday", exercises: ["Stretching"]),
                       GymPlan(day: "Sunday", exercises: ["Rest"])
                   ]
                   mealSchedule = [
                       MealPlan(day: "Monday", meals: ["Breakfast: Protein Shake", "Lunch: Chicken Wrap", "Dinner: Steamed Veggies"]),
                       MealPlan(day: "Tuesday", meals: ["Breakfast: Scrambled Eggs", "Lunch: Tuna Salad", "Dinner: Grilled Steak"]),
                       MealPlan(day: "Wednesday", meals: ["Breakfast: Greek Yogurt", "Lunch: Lentil Soup", "Dinner: Grilled Fish"])
                   ]

               case 16: // Vegan Nutrition 17
                   gymSchedule = [
                       GymPlan(day: "Monday", exercises: ["Yoga: 30 mins"]),
                       GymPlan(day: "Tuesday", exercises: ["Light Cardio"]),
                       GymPlan(day: "Wednesday", exercises: ["Stretching"]),
                       GymPlan(day: "Thursday", exercises: ["Bodyweight Exercises"]),
                       GymPlan(day: "Friday", exercises: ["Rest"]),
                       GymPlan(day: "Saturday", exercises: ["Foam Rolling"]),
                       GymPlan(day: "Sunday", exercises: ["Meditation"])
                   ]
                   mealSchedule = [
                       MealPlan(day: "Monday", meals: ["Breakfast: Smoothie Bowl", "Lunch: Lentil Salad", "Dinner: Quinoa and Veggies"]),
                       MealPlan(day: "Tuesday", meals: ["Breakfast: Avocado Toast", "Lunch: Grilled Veggie Wrap", "Dinner: Baked Sweet Potato"]),
                       MealPlan(day: "Wednesday", meals: ["Breakfast: Scrambled Tofu", "Lunch: Chickpea Salad", "Dinner: Veggie Stir Fry"])
                   ]

               case 17: // Postpartum Fitness 18
                   gymSchedule = [
                       GymPlan(day: "Monday", exercises: ["Gentle Yoga"]),
                       GymPlan(day: "Tuesday", exercises: ["Walking"]),
                       GymPlan(day: "Wednesday", exercises: ["Breathing and Relaxation"]),
                       GymPlan(day: "Thursday", exercises: ["Stretching"]),
                       GymPlan(day: "Friday", exercises: ["Resistance Band Exercises"]),
                       GymPlan(day: "Saturday", exercises: ["Rest"]),
                       GymPlan(day: "Sunday", exercises: ["Active Recovery"])
                   ]
                   mealSchedule = [
                       MealPlan(day: "Monday", meals: ["Breakfast: Smoothie Bowl", "Lunch: Lentil Soup", "Dinner: Steamed Veggies"]),
                       MealPlan(day: "Tuesday", meals: ["Breakfast: Greek Yogurt", "Lunch: Veggie Wrap", "Dinner: Grilled Fish"]),
                       MealPlan(day: "Wednesday", meals: ["Breakfast: Pancakes", "Lunch: Tuna Salad", "Dinner: Chicken Stir Fry"])
                   ]

               case 18: // Core Strength 19
                   gymSchedule = [
                       GymPlan(day: "Monday", exercises: ["Plank Variations"]),
                       GymPlan(day: "Tuesday", exercises: ["Core Circuits"]),
                       GymPlan(day: "Wednesday", exercises: ["Foam Rolling"]),
                       GymPlan(day: "Thursday", exercises: ["Stretching"]),
                       GymPlan(day: "Friday", exercises: ["Rest"]),
                       GymPlan(day: "Saturday", exercises: ["Pilates"]),
                       GymPlan(day: "Sunday", exercises: ["Yoga"])
                   ]
                   mealSchedule = [
                       MealPlan(day: "Monday", meals: ["Breakfast: Protein Shake", "Lunch: Grilled Veggie Wrap", "Dinner: Lentil Soup"]),
                       MealPlan(day: "Tuesday", meals: ["Breakfast: Scrambled Eggs", "Lunch: Chicken Wrap", "Dinner: Grilled Salmon"]),
                       MealPlan(day: "Wednesday", meals: ["Breakfast: Smoothie Bowl", "Lunch: Salad with Chickpeas", "Dinner: Baked  Potatoes"])
                    ]

            case 19: // Youth Fitness 20
                    gymSchedule = [
                        GymPlan(day: "Monday", exercises: ["Active Games: 30 mins", "Bodyweight Squats: 2x10"]),
                        GymPlan(day: "Tuesday", exercises: ["Light Jogging: 15 mins", "Plank: 2x20 sec"]),
                        GymPlan(day: "Wednesday", exercises: ["Stretching Routine: 20 mins"]),
                        GymPlan(day: "Thursday", exercises: ["Bike Riding: 30 mins", "Push-Ups: 2x8"]),
                        GymPlan(day: "Friday", exercises: ["Dancing: 20 mins", "Sit-Ups: 2x12"]),
                        GymPlan(day: "Saturday", exercises: ["Outdoor Play: 40 mins"]),
                        GymPlan(day: "Sunday", exercises: ["Rest or Family Walk"])
                    ]
                    mealSchedule = [
                        MealPlan(day: "Monday", meals: ["Breakfast: Cereal with Milk", "Lunch: Turkey Sandwich", "Dinner: Grilled Chicken with Veggies"]),
                        MealPlan(day: "Tuesday", meals: ["Breakfast: Yogurt with Berries", "Lunch: Cheese Quesadilla", "Dinner: Pasta with Meat Sauce"]),
                        MealPlan(day: "Wednesday", meals: ["Breakfast: Banana Pancakes", "Lunch: Ham Wrap", "Dinner: Fish Fingers with Sweet Potato Fries"])
                    ]
            
            case 20: // Pre-Diabetes Management 21
                gymSchedule = [
                    GymPlan(day: "Monday", exercises: ["Brisk Walking: 20 mins", "Bodyweight Exercises: 3x10"]),
                    GymPlan(day: "Tuesday", exercises: ["Light Cycling: 30 mins"]),
                    GymPlan(day: "Wednesday", exercises: ["Yoga: 25 mins"]),
                    GymPlan(day: "Thursday", exercises: ["Strength Training: 3x8"]),
                    GymPlan(day: "Friday", exercises: ["Aerobic Dance: 20 mins"]),
                    GymPlan(day: "Saturday", exercises: ["Outdoor Walk: 30 mins"]),
                    GymPlan(day: "Sunday", exercises: ["Rest"])
                ]
                mealSchedule = [
                    MealPlan(day: "Monday", meals: ["Breakfast: Avocado Toast", "Lunch: Grilled Fish Salad", "Dinner: Baked Chicken with Steamed Broccoli"]),
                    MealPlan(day: "Tuesday", meals: ["Breakfast: Greek Yogurt", "Lunch: Quinoa Bowl", "Dinner: Lentil Soup with Whole Grain Bread"]),
                    MealPlan(day: "Wednesday", meals: ["Breakfast: Smoothie Bowl", "Lunch: Tuna Salad", "Dinner: Zucchini Noodles with Marinara"])
                ]
            
        case 21: // Arthritis-Friendly Workouts 22
                gymSchedule = [
                    GymPlan(day: "Monday", exercises: ["Water Aerobics: 30 mins"]),
                    GymPlan(day: "Tuesday", exercises: ["Yoga for Joint Health: 20 mins"]),
                    GymPlan(day: "Wednesday", exercises: ["Light Resistance Band Work: 15 mins"]),
                    GymPlan(day: "Thursday", exercises: ["Walking on Soft Terrain: 25 mins"]),
                    GymPlan(day: "Friday", exercises: ["Chair Exercises: 15 mins"]),
                    GymPlan(day: "Saturday", exercises: ["Stretching and Mobility Work"]),
                    GymPlan(day: "Sunday", exercises: ["Rest or Gentle Stroll"])
                ]
                mealSchedule = [
                    MealPlan(day: "Monday", meals: ["Breakfast: Oatmeal with Almonds", "Lunch: Grilled Salmon Salad", "Dinner: Steamed Vegetables with Chicken"]),
                    MealPlan(day: "Tuesday", meals: ["Breakfast: Smoothie with Spinach", "Lunch: Lentil Soup", "Dinner: Baked Fish with Sweet Potato"]),
                    MealPlan(day: "Wednesday", meals: ["Breakfast: Whole Grain Toast with Peanut Butter", "Lunch: Chickpea Salad", "Dinner: Roasted Turkey"])
                ]

        case 22: // Marathon Training 23
                gymSchedule = [
                    GymPlan(day: "Monday", exercises: ["Distance Run: 5 miles"]),
                    GymPlan(day: "Tuesday", exercises: ["Strength Training: 3x10"]),
                    GymPlan(day: "Wednesday", exercises: ["Rest or Light Jog: 3 miles"]),
                    GymPlan(day: "Thursday", exercises: ["Speed Work: 10x200m sprints"]),
                    GymPlan(day: "Friday", exercises: ["Cross Training: 30 mins"]),
                    GymPlan(day: "Saturday", exercises: ["Long Run: 10 miles"]),
                    GymPlan(day: "Sunday", exercises: ["Rest"])
                ]
                mealSchedule = [
                    MealPlan(day: "Monday", meals: ["Breakfast: Protein Smoothie", "Lunch: Pasta Salad", "Dinner: Grilled Chicken with Quinoa"]),
                    MealPlan(day: "Tuesday", meals: ["Breakfast: Whole Grain Toast with Eggs", "Lunch: Turkey Wrap", "Dinner: Salmon with Rice"]),
                    MealPlan(day: "Wednesday", meals: ["Breakfast: Pancakes with Berries", "Lunch: Chicken Caesar Salad", "Dinner: Stir-Fry with Veggies"])
                ]

        case 23: // Desk Job Fitness 24
            gymSchedule = [
                GymPlan(day: "Monday", exercises: ["Desk Stretching: 10 mins", "Light Yoga"]),
                GymPlan(day: "Tuesday", exercises: ["Walking Breaks: 20 mins"]),
                GymPlan(day: "Wednesday", exercises: ["Resistance Band Work: 15 mins"]),
                GymPlan(day: "Thursday", exercises: ["Core Activation Exercises"]),
                GymPlan(day: "Friday", exercises: ["Stretching Routine: 15 mins"]),
                GymPlan(day: "Saturday", exercises: ["Active Recreation"]),
                GymPlan(day: "Sunday", exercises: ["Rest"])
            ]
            mealSchedule = [
                MealPlan(day: "Monday", meals: ["Breakfast: Avocado Toast", "Lunch: Tuna Salad", "Dinner: Grilled Chicken"]),
                MealPlan(day: "Tuesday", meals: ["Breakfast: Smoothie Bowl", "Lunch: Vegetable Wrap", "Dinner: Baked Fish"]),
                MealPlan(day: "Wednesday", meals: ["Breakfast: Yogurt with Granola", "Lunch: Turkey Sandwich", "Dinner: Stir-Fried Vegetables"])
            ]

        case 24: // Sleep Improvemen 25
            gymSchedule = [
                GymPlan(day: "Monday", exercises: ["Relaxation Yoga: 20 mins"]),
                GymPlan(day: "Tuesday", exercises: ["Light Walking: 30 mins"]),
                GymPlan(day: "Wednesday", exercises: ["Deep Breathing Exercises: 10 mins"]),
                GymPlan(day: "Thursday", exercises: ["Meditation: 15 mins"]),
                GymPlan(day: "Friday", exercises: ["Stretching and Mobility: 20 mins"]),
                GymPlan(day: "Saturday", exercises: ["Gentle Evening Walk: 15 mins"]),
                GymPlan(day: "Sunday", exercises: ["Rest"])
            ]
            mealSchedule = [
                MealPlan(day: "Monday", meals: ["Breakfast: Oatmeal with Walnuts", "Lunch: Quinoa Salad", "Dinner: Grilled Salmon with Spinach"]),
                MealPlan(day: "Tuesday", meals: ["Breakfast: Yogurt with Berries", "Lunch: Chicken Wrap", "Dinner: Lentil Soup"]),
                MealPlan(day: "Wednesday", meals: ["Breakfast: Smoothie Bowl", "Lunch: Veggie Stir-Fry", "Dinner: Herb-Baked Chicken"])
            ]

        default:
            break
        }
    }
}

