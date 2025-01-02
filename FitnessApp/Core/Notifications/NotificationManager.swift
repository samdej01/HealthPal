import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()

    private init() {}

    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notifications permission: \(error.localizedDescription)")
            }
            print("Notification permission granted: \(granted)")
        }
    }

    // Workout Reminder Noticication
    func scheduleWorkoutReminder(at hour: Int, minute: Int) {
        let content = UNMutableNotificationContent()
        content.title = "Time to Workout!"
        content.body = "Stay active and achieve your fitness goals. Let's do this!"
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "WorkoutReminder", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule workout reminder: \(error.localizedDescription)")
            }
        }
    }

    // Health Risk Notification
    func notifyHealthRisk(for condition: String) {
        let content = UNMutableNotificationContent()
        content.title = "Health Alert"
        content.body = "Your recent data indicates \(condition). Please take appropriate measures or consult a professional."
        content.sound = .default

        let request = UNNotificationRequest(identifier: "HealthRiskAlert", content: content, trigger: nil)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to send health risk notification: \(error.localizedDescription)")
            }
        }
    }

    // Schedule Affirmation Notification
    func scheduleAffirmation() {
        let affirmations = [
            "You're beautiful.",
            "You deserve the world.",
            "I hope you have a good day.",
            "You are strong and capable.",
            "Keep going; you're doing great!"
        ]

        let content = UNMutableNotificationContent()
        content.title = "Daily Affirmation"
        content.body = affirmations.randomElement()!
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 86400, repeats: true) // Once a day
        let request = UNNotificationRequest(identifier: "AffirmationNotification", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule affirmation notification: \(error.localizedDescription)")
            }
        }
    }
}
