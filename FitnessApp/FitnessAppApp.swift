import SwiftUI
import RevenueCat
import FirebaseCore
import UserNotifications

@main
struct FitnessAppApp: App {

    init() {
        // Revenue Cat Setup
        Purchases.logLevel = .debug
        Purchases.configure(withAPIKey: "appl_OiZLcmUmVWNwiitRslmiiogTxFn")
        
        // Firebase Setup
        FirebaseApp.configure()

        // Request Notification Permission
        requestNotificationPermission()
        
        // Schedule a workout reminder for 9:00 AM
        NotificationManager.shared.scheduleWorkoutReminder(at: 9, minute: 0)
        
        // Simulate checking heart rate and triggering a health risk notification
        checkUserHeartRate(heartRate: 125)  // Example heart rate exceeding 120 bpm
    }
    
    var body: some Scene {
        WindowGroup {
            FitnessTabView()
        }
    }

    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notifications permission: \(error.localizedDescription)")
            }
            print("Notification permission granted: \(granted)")
        }
    }

    // Simulate checking heart rate and sending notification if heart rate exceeds 120 bpm
    func checkUserHeartRate(heartRate: Int) {
        if heartRate > 120 {
            NotificationManager.shared.notifyHealthRisk(for: "your heart rate is too high (\(heartRate) bpm).")
        }
    }
}
