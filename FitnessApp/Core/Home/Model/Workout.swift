import SwiftUI
struct Workout: Hashable, Identifiable {
    let id = UUID()
    let title: String
    let image: String
    let tintColor: Color
    let duration: String
    let date: Date
    let calories: String
}
