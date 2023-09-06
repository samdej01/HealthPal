//
//  LeaderboardViewModel.swift
//  FitnessApp
//
//  Created by Jason Dubon on 8/17/23.
//

import Foundation

class LeaderboardViewModel: ObservableObject {
    
    @Published var leaderResult = LeaderboardResult(user: nil, top10: [])
    @Published var showAlert = false
    
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
    
    init() {
        setupLeaderboardData()
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
        let leaders = try await DatabaseManager.shared.fetchLeaderboards()
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
        
        let steps = try await fetchCurrentWeekStepCount()
        try await DatabaseManager.shared.postStepCountUpdateForUser(leader: LeaderboardUser(username: username, count: Int(steps)))
    }
    
    private func fetchCurrentWeekStepCount() async throws -> Double {
        try await withCheckedThrowingContinuation({ continuation in
            HealthManager.shared.fetchCurrentWeekStepCount { result in
                continuation.resume(with: result)
            }
        })
    }
}
