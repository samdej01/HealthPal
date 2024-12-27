
import Foundation

struct DailyStepModel: Identifiable {
    let id = UUID()
    let date: Date
    let count: Int
}
