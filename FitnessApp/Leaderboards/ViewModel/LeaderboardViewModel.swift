//
//  LeaderboardViewModel.swift
//  FitnessApp
//
//  Created by Jason Dubon on 8/17/23.
//

import Foundation

class LeaderboardViewModel: ObservableObject {
    
    @Published var leaders = [LeaderboardUser]()
    
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
        
        Task {
            do {
                try await postStepCountUpdateForUser(username: "xcode", count: 123)
                let result = try await fetchLeaderboards()
                DispatchQueue.main.async {
                    self.leaders = result.top10
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        
    }
    
    struct LeaderboardResult {
        let user: LeaderboardUser?
        let top10: [LeaderboardUser]
    }
    
    func fetchLeaderboards() async throws -> LeaderboardResult {
        let leaders = try await DatabaseManager.shared.fetchLeaderboards()
        let top10 = Array(leaders.sorted(by: { $0.count > $1.count }).prefix(10))
        let username = UserDefaults.standard.string(forKey: "username")
        
        if let username = username {
            let user = leaders.first(where: { $0.username == username })
            return LeaderboardResult(user: user, top10: top10)
        } else {
            return LeaderboardResult(user: nil, top10: top10)
        }
    }
    
    func postStepCountUpdateForUser(username: String, count: Int) async throws {
        try await DatabaseManager.shared.postStepCountUpdateForUser(leader: LeaderboardUser(username: username, count: count))
    }
}
