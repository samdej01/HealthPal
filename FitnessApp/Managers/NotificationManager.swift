//
//  NotificationManager.swift
//  FitnessApp
//
//  Created by Unicorn Semi on 21/01/2025.
//


import UserNotifications

class NotificationManager {
    static let shared = NotificationManager() // Singleton instance
    
    private init() {}
    
    /// Requests notification permission from the user
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notification permission: \(error)")
            } else {
                print("Notification permission granted: \(granted)")
            }
        }
    }

    /// Schedule workout reminders at 10:00 AM and 8:00 PM daily
    func scheduleWorkoutReminders() {
        let center = UNUserNotificationCenter.current()
        
        // Morning reminder
        let morningContent = UNMutableNotificationContent()
        morningContent.title = "Morning Workout Reminder"
        morningContent.body = "It's time to get active and crush your goals!"
        morningContent.sound = .default
        
        var morningTrigger = DateComponents()
        morningTrigger.hour = 10
        let morningNotification = UNNotificationRequest(
            identifier: "WorkoutMorningReminder",
            content: morningContent,
            trigger: UNCalendarNotificationTrigger(dateMatching: morningTrigger, repeats: true)
        )
        
        // Evening reminder
        let eveningContent = UNMutableNotificationContent()
        eveningContent.title = "Evening Workout Reminder"
        eveningContent.body = "Wrap up your day with a great workout!"
        eveningContent.sound = .default
        
        var eveningTrigger = DateComponents()
        eveningTrigger.hour = 20
        let eveningNotification = UNNotificationRequest(
            identifier: "WorkoutEveningReminder",
            content: eveningContent,
            trigger: UNCalendarNotificationTrigger(dateMatching: eveningTrigger, repeats: true)
        )
        
        // Schedule both reminders
        center.add(morningNotification) { error in
            if let error = error {
                print("Failed to schedule morning workout reminder: \(error.localizedDescription)")
            }
        }
        center.add(eveningNotification) { error in
            if let error = error {
                print("Failed to schedule evening workout reminder: \(error.localizedDescription)")
            }
        }
    }

    /// Schedule daily affirmations at random times (5 times a day) - 25 to choose from
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
            "I are strong, healthy, and full of energy.",
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
            "Your potential is limitless."
        ]
        
        for i in 1...5 { // Schedule 5 affirmations daily
            let content = UNMutableNotificationContent()
            content.title = "Daily Affirmation"
            content.body = affirmations.randomElement() ?? "You are amazing!"
            content.sound = .default
            
            let randomHour = Int.random(in: 8...22) // Between 8 AM and 10 PM
            let randomMinute = Int.random(in: 0...59)
            
            var triggerDate = DateComponents()
            triggerDate.hour = randomHour
            triggerDate.minute = randomMinute
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)
            let request = UNNotificationRequest(
                identifier: "Affirmation-\(i)",
                content: content,
                trigger: trigger
            )
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Failed to schedule affirmation \(i): \(error.localizedDescription)")
                }
            }
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
}
