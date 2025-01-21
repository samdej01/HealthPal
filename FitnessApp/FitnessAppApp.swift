import SwiftUI
import RevenueCat
import FirebaseCore
import UserNotifications

@main
struct FitnessAppApp: App {
    
    init() {
        // RevenueCat Setup
        Purchases.logLevel = .debug
        Purchases.configure(withAPIKey: "appl_OiZLcmUmVWNwiitRslmiiogTxFn")
        
        // Firebase Setup
        FirebaseApp.configure()
        
        // Request Notification Permission
        NotificationManager.shared.requestNotificationPermission()
        
        // Schedule Notifications
        NotificationManager.shared.scheduleWorkoutReminders() // Morning & Evening workout reminders
        NotificationManager.shared.scheduleAffirmationNotifications() // Daily affirmations
    }
    
    var body: some Scene {
        WindowGroup {
            FitnessTabView()
                .onAppear {
                    // Simulate checking heart rate dynamically (you'll replace this with real logic later)
                    simulateHeartRateCheck()
                }
        }
    }
    
    /// Simulate checking heart rate and triggering health risk alerts
    func simulateHeartRateCheck() {
        let exampleHeartRate: Int = 125 // Replace with actual heart rate fetched from HealthKit
        HealthManager.shared.checkHeartRate(Double(exampleHeartRate)) // Convert to Double
    }
}
