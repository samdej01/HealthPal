//
//  DatabaseManager.swift
//  FitnessApp
//
//  Created by Jason Dubon on 8/16/23.
//

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
    
    // Fetch Leaderboards
    func fetchLeaderboards() async throws -> [LeaderboardUser] {
        let snapshot = try await database.collection(weeklyLeaderboard).getDocuments()
        return try snapshot.documents.compactMap({ try $0.data(as: LeaderboardUser.self) })
    }
    
    // Post (Update) Leaderboards for current user
    func postStepCountUpdateForUser(leader: LeaderboardUser) async throws {
        let data = try Firestore.Encoder().encode(leader)
        try await database.collection(weeklyLeaderboard).document(leader.username).setData(data, merge: false)
    }
}
