//
//  LeaderboardUser.swift
//  FitnessApp
//
//  Created by Jason Dubon on 8/17/23.
//

import Foundation

struct LeaderboardUser: Codable, Identifiable {
    let id = UUID()
    let username: String
    let count: Int
}
