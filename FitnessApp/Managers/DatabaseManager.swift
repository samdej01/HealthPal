//
//  DatabaseManager.swift
//  FitnessApp
//
//  Created by Jason Dubon on 8/16/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private init() { }
    
    let database = Firestore.firestore()
    let weeklyLeaderboard = "\(Date().mondayDateFormat())-leaderboard"
    
    // Fetch Leaderboards
    func fetchLeaderboards() async throws {
        let snapshot = try await database.collection(weeklyLeaderboard).getDocuments()
        
        print(snapshot.documents)
        print(snapshot.documents.first?.data())
        
    }
    
    // Post (Update) Leaderboards for current user
    func postStepCountUpdateFor(username: String, count: Int) async throws {
        let leader = LeaderboardUser(username: username, count: count)
        let data = try Firestore.Encoder().encode(leader)
        try await database.collection(weeklyLeaderboard).document(username).setData(data, merge: false)
    }
}
