import Foundation

class KMeansModel {
    private var centroids: [[Double]] = []
    private var clusters: [[Int]] = []

    func fit(data: [[Double]], k: Int) {
        centroids = Array(data.prefix(k))
        clusters = Array(repeating: [], count: k)

        for _ in 0..<10 {
            clusters = Array(repeating: [], count: k)

            for (i, point) in data.enumerated() {
                let closestCentroid = centroids.enumerated().min {
                    euclideanDistance($0.1, point) < euclideanDistance($1.1, point)
                }!.0
                clusters[closestCentroid].append(i)
            }

            for i in 0..<k {
                centroids[i] = clusters[i].map { data[$0] }
                    .reduce([0.0, 0.0, 0.0]) { zip($0, $1).map(+) }
                    .map { $0 / Double(clusters[i].count) }
            }
        }
    }

    func predict(features: [Double]) -> Int {
        return centroids.enumerated().min {
            euclideanDistance($0.1, features) < euclideanDistance($1.1, features)
        }!.0
    }

    func getMealPlans(forCluster cluster: Int) -> [String] {
        let mealOptions = [
            "Breakfast: Oatmeal with berries",
            "Lunch: Grilled chicken with quinoa",
            "Dinner: Baked salmon with asparagus",
            "Breakfast: Smoothie bowl with almond butter",
            "Lunch: Turkey wrap with avocado",
            "Dinner: Stir-fried tofu and vegetables",
            "Breakfast: Greek yogurt with granola"
        ]
        return Array(mealOptions.prefix(7))
    }

    func getGymPlans(forCluster cluster: Int) -> [String] {
        let exerciseOptions = [
            "3 sets of push-ups (15 reps each)",
            "3 sets of burpees (10 reps each)",
            "3 sets of squats (20 reps each)",
            "Plank hold for 1 minute (3 sets)",
            "Mountain climbers (30 seconds x 3 sets)",
            "Jumping jacks (2 minutes x 3 sets)",
            "3 sets of lunges (15 reps each leg)"
        ]
        return Array(exerciseOptions.prefix(7))
    }

    private func euclideanDistance(_ a: [Double], _ b: [Double]) -> Double {
        return sqrt(zip(a, b).map { pow($0 - $1, 2) }.reduce(0, +))
    }
}
