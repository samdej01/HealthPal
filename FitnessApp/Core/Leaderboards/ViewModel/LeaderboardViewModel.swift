//
//  LeaderboardViewModel.swift
//  FitnessApp
//
//  Created by Jason Dubon on 8/17/23.
//

import Foundation

@Observable
final class LeaderboardViewModel {
    
    var termsViewUsername = ""
    var acceptedTerms = false
    var didCompleteAccepting = false
    
    var username = UserDefaults.standard.string(forKey: "username")
    var leaderResult = LeaderboardResult(user: nil, top10: [])
    var showAlert = false
    
    var mockData = [
        LeaderboardUser(username: "jason", count: 4124),
        LeaderboardUser(username: "you", count: 1124),
        LeaderboardUser(username: "seanallen", count: 41204),
        LeaderboardUser(username: "paul hudson", count: 4124),
        LeaderboardUser(username: "catalin", count: 11124),
        LeaderboardUser(username: "logan", count: 124),
        LeaderboardUser(username: "jason", count: 4124),
        LeaderboardUser(username: "you", count: 1124),
        LeaderboardUser(username: "seanallen", count: 41204),
        LeaderboardUser(username: "paul hudson", count: 4124),
        LeaderboardUser(username: "catalin", count: 11124),
        LeaderboardUser(username: "logan", count: 124),
    ]
    
    var healthManager: HealthManagerType
    var databaseManager: DatabaseManagerType
    
    init(healthManager: HealthManagerType = HealthManager.shared, databaseManager: 
        DatabaseManagerType = DatabaseManager.shared) {
        self.healthManager = healthManager
        self.databaseManager = databaseManager
        if username != nil {
            setupLeaderboardData()
        }
    }
    
    func acceptedTermsAndSignedUp() {
        if acceptedTerms && termsViewUsername.count > 2 {
            UserDefaults.standard.set(termsViewUsername, forKey: "username")
            didCompleteAccepting = true
        }
    }
    
    func setupLeaderboardData() {
        Task {
            do {
                try await postStepCountUpdateForUser()
                let result = try await fetchLeaderboards()
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.leaderResult = result
                }
            } catch {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.showAlert = true
                }
            }
        }
    }
    
    struct LeaderboardResult {
        let user: LeaderboardUser?
        let top10: [LeaderboardUser]
    }
    
    private func fetchLeaderboards() async throws -> LeaderboardResult {
        let leaders = try await databaseManager.fetchLeaderboards()
        let top10 = Array(leaders.sorted(by: { $0.count > $1.count }).prefix(10))
        let username = UserDefaults.standard.string(forKey: "username")
    
        if let username = username, !top10.contains(where: { $0.username == username }) {
            let user = leaders.first(where: { $0.username == username })
            return LeaderboardResult(user: user, top10: top10)
        } else {
            return LeaderboardResult(user: nil, top10: top10)
        }
    }
    
    enum LeaderboardViewModelError: Error {
        case unableToFetchUsername
    }
    
    private func postStepCountUpdateForUser() async throws {
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            throw LeaderboardViewModelError.unableToFetchUsername
        }
        
        // When current week steps throws and error (steps is nil) make step count 0
        let steps = try? await fetchCurrentWeekStepCount()
        try await databaseManager.postStepCountUpdateForUser(leader: LeaderboardUser(username: username, count: Int(steps ?? 0)))
    }
    
    private func fetchCurrentWeekStepCount() async throws -> Double {
        try await withCheckedThrowingContinuation({ continuation in
            healthManager.fetchCurrentWeekStepCount { result in
                continuation.resume(with: result)
            }
        })
    }
}
