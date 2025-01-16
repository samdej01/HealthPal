//
//  KMeansModel.swift
//  FitnessApp
//
//  Created by Unicorn Semi on 16/01/2025.
//


import Foundation

class KMeansModel {
    private var centroids: [[Double]] = []
    private var clusters: [[Int]] = []
    
    func fit(data: [[Double]], k: Int) {
        centroids = Array(data.prefix(k)) // Initialize centroids
        clusters = Array(repeating: [], count: k)
        
        for _ in 0..<10 { // Iterate for convergence
            clusters = Array(repeating: [], count: k)
            
            for (i, point) in data.enumerated() {
                let closestCentroid = centroids.enumerated().min(by: { 
                    euclideanDistance($0.1, point) < euclideanDistance($1.1, point)
                })!.0
                clusters[closestCentroid].append(i)
            }
            
            for i in 0..<k {
                centroids[i] = clusters[i].map { data[$0] }.reduce([0, 0, 0], { zip($0, $1).map(+) }).map { $0 / Double(clusters[i].count) }
            }
        }
    }
    
    func predict(features: [Double]) -> Int {
        return centroids.enumerated().min(by: { 
            euclideanDistance($0.1, features) < euclideanDistance($1.1, features)
        })!.0
    }
    
    func getMealPlans(forCluster cluster: Int) -> [Plan] {
        let plans = [
            [Plan(title: "Breakfast", description: "Oatmeal and almond milk"), 
             Plan(title: "Lunch", description: "Chicken salad"), 
             Plan(title: "Dinner", description: "Grilled salmon")],
             
            [Plan(title: "Breakfast", description: "Greek yogurt and granola"), 
             Plan(title: "Lunch", description: "Turkey wrap"), 
             Plan(title: "Dinner", description: "Stir-fried tofu")],
             
            [Plan(title: "Breakfast", description: "Protein shake and banana"), 
             Plan(title: "Lunch", description: "Steak and vegetables"), 
             Plan(title: "Dinner", description: "Grilled chicken")]
        ]
        return plans[cluster]
    }
    
    func getGymPlans(forCluster cluster: Int) -> [Plan] {
        let plans = [
            [Plan(title: "Day 1: Cardio", description: "30-minute run"), 
             Plan(title: "Day 2: Recovery", description: "Yoga and stretching")],
             
            [Plan(title: "Day 1: Strength", description: "Upper-body weight training"), 
             Plan(title: "Day 2: Cardio", description: "Cycling and sprints")],
             
            [Plan(title: "Day 1: High-Intensity Training", description: "HIIT circuit"), 
             Plan(title: "Day 2: Heavy Lifting", description: "Lower-body weights")]
        ]
        return plans[cluster]
    }
    
    private func euclideanDistance(_ a: [Double], _ b: [Double]) -> Double {
        return sqrt(zip(a, b).map { pow($0 - $1, 2) }.reduce(0, +))
    }
}
