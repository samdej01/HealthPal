import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()

    private init() {}

    /// Requests notification permissions from the user.
    func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                    if let error = error {
                        print("Error requesting notifications permission: \(error.localizedDescription)")
                    } else {
                        print("Notification permission granted: \(granted)")
                    }
                }
            case .denied:
                print("Notifications are denied. Please enable them in Settings.")
            case .authorized, .provisional, .ephemeral:
                print("Notifications are already authorized.")
            @unknown default:
                fatalError("Unhandled case: \(settings.authorizationStatus)")
            }
        }
    }

    // MARK: - Workout Reminder Notification
    /// Schedules a daily workout reminder notification at the specified time.
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
            } else {
                print("Workout reminder scheduled successfully.")
            }
        }
    }

    // MARK: - Health Risk Notification
    /// Sends a health risk notification immediately.
    func notifyHealthRisk(for condition: String) {
        let content = UNMutableNotificationContent()
        content.title = "Health Alert"
        content.body = "Your recent data indicates \(condition). Please take appropriate measures or consult a professional."
        content.sound = .default

        let request = UNNotificationRequest(identifier: "HealthRiskAlert", content: content, trigger: nil)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to send health risk notification: \(error.localizedDescription)")
            } else {
                print("Health risk notification sent successfully.")
            }
        }
    }

    // MARK: - Daily Affirmation Notification
    /// Schedules a daily affirmation notification.
    func scheduleAffirmation(at hour: Int, minute: Int) {
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

        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "AffirmationNotification", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule affirmation notification: \(error.localizedDescription)")
            } else {
                print("Daily affirmation notification scheduled successfully.")
            }
        }
    }
}
