import UserNotifications

class NotificationManager {
    static let shared = NotificationManager() // Singleton instance
    
    private init() {}
    
    /// Requests notification permission from the user
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notification permission: \(error.localizedDescription)")
            } else {
                print("Notification permission granted: \(granted)")
            }
        }
    }

    /// Schedule workout reminders at 10:00 AM and 8:00 PM daily
    func scheduleWorkoutReminders() {
        // Morning reminder
        scheduleNotification(
            atHour: 10,
            minute: 0,
            title: "Morning Workout Reminder",
            body: "It's time to get active and crush your goals!",
            identifier: "WorkoutMorningReminder"
        )

        // Evening reminder
        scheduleNotification(
            atHour: 20,
            minute: 0,
            title: "Evening Workout Reminder",
            body: "Wrap up your day with a great workout!",
            identifier: "WorkoutEveningReminder"
        )
    }

    /// Schedule daily affirmations at random times (5 times a day) - 30 to choose from
    func scheduleAffirmationNotifications() {
        let affirmations = [
            "You're beautiful.",
            "You deserve the world.",
            "I hope you have a good day.",
            "Your hard work is paying off.",
            "Believe in yourself; you’re unstoppable.",
            "You are strong and capable.",
            "Keep going; you're doing great!",
            "Take a deep breath; you're amazing!",
            "Every step you take brings you closer to your fitness goals.",
            "You are strong, healthy, and full of energy.",
            "Today is full of endless possibilities.",
            "Be kind to yourself today.",
            "You light up the world with your unique energy.",
            "Trust the process; you’re on the right path.",
            "You’ve got this—one step at a time.",
            "You are worthy of love and care.",
            "You are capable of incredible things.",
            "Your body is strong, and your mind is powerful.",
            "You are enough exactly as you are.",
            "You have the power to create a positive impact.",
            "You are capable of overcoming any challenge.",
            "You’re doing so much better than you realize.",
            "You are loved and supported.",
            "You have the strength to overcome any obstacle.",
            "Your potential is limitless.",
            "You are capable of amazing things.",
            "You are loved and cherished.",
            "You have the power to change your life.",
            "You are amazing!",
            "You have the power to achieve your dreams."
        ]

        for i in 1...5 { // Schedule 5 affirmations daily
            let randomHour = Int.random(in: 8...22) // Between 8 AM and 10 PM
            let randomMinute = Int.random(in: 0...59)
            let affirmation = affirmations.randomElement() ?? "You are amazing!"

            scheduleNotification(
                atHour: randomHour,
                minute: randomMinute,
                title: "Daily Affirmation",
                body: affirmation,
                identifier: "Affirmation-\(i)"
            )
        }
    }

    /// Sends health risk alert dynamically based on user condition
    func notifyHealthRisk(for condition: String) {
        let content = UNMutableNotificationContent()
        content.title = "Health Alert"
        content.body = "Your recent data indicates \(condition). Please consult a doctor if needed."
        content.sound = .default

        let request = UNNotificationRequest(identifier: "HealthRiskAlert", content: content, trigger: nil)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to send health alert: \(error.localizedDescription)")
            }
        }
    }

    /// Disables all pending notifications
    func disableAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        print("All notifications disabled.")
    }

    /// Helper function to schedule notifications
    private func scheduleNotification(atHour hour: Int, minute: Int, title: String, body: String, identifier: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification \(identifier): \(error.localizedDescription)")
            }
        }
    }
}
