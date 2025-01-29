import Foundation

class KMeansModel {
    private var centroids: [[Double]] = []
    private var clusters: [[Int]] = []

    /// Fits the KMeans algorithm with the dataset
    func fit(data: [[Double]], k: Int) {
        // Initialize centroids as the first 'k' data points
        centroids = Array(data.prefix(k))
        clusters = Array(repeating: [], count: k)

        // Repeat optimization for a fixed number of iterations
        for _ in 0..<10 {
            clusters = Array(repeating: [], count: k)

            // Assign each point to the nearest centroid
            for (i, point) in data.enumerated() {
                let closestCentroid = centroids.enumerated().min {
                    euclideanDistance($0.1, point) < euclideanDistance($1.1, point)
                }!.0
                clusters[closestCentroid].append(i)
            }

            // Recalculate centroids based on cluster points
            for i in 0..<k {
                let clusterPoints = clusters[i].map { data[$0] }
                guard !clusterPoints.isEmpty else { continue }
                centroids[i] = clusterPoints.reduce([0.0, 0.0]) { zip($0, $1).map(+) }
                    .map { $0 / Double(clusterPoints.count) }
            }
        }
    }
    /// Predicts the cluster for a given feature set
    func predict(features: [Double]) -> Int {
        return centroids.enumerated().min {
            euclideanDistance($0.1, features) < euclideanDistance($1.1, features)
        }!.0
    }
    /// Helper function: Euclidean Distance
    private func euclideanDistance(_ a: [Double], _ b: [Double]) -> Double {
        return sqrt(zip(a, b).map { pow($0 - $1, 2) }.reduce(0, +))
    }
}
