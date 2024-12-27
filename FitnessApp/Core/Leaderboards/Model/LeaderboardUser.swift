
import Foundation

struct LeaderboardUser: Codable, Identifiable {
    var id = UUID()
    let username: String
    let count: Int
}
