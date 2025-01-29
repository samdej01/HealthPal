
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol DatabaseManagerType {
    func fetchLeaderboards() async throws -> [LeaderboardUser]
    func postStepCountUpdateForUser(leader: LeaderboardUser) async throws
}

final class DatabaseManager: DatabaseManagerType {
    
    static let shared = DatabaseManager()
    
    private init() { }
    
    private let database = Firestore.firestore()
    private let weeklyLeaderboard = "\(Date().mondayDateFormat())-leaderboard"
    
    /// Returns an array of all leaders for current week
    /// - Returns: Array of leaders.
    func fetchLeaderboards() async throws -> [LeaderboardUser] {
        let snapshot = try await database.collection(weeklyLeaderboard).getDocuments()
        return try snapshot.documents.compactMap({ try $0.data(as: LeaderboardUser.self) })
    }
    
    /// Posts and/or updates the step count for current user
    /// - Parameters:
    ///   - leader: LeaderboardUser (username & step count).
    func postStepCountUpdateForUser(leader: LeaderboardUser) async throws {
        let data = try Firestore.Encoder().encode(leader)
        try await database.collection(weeklyLeaderboard).document(leader.username).setData(data, merge: false)
    }
}

