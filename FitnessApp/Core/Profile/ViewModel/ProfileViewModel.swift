import SwiftUI

@Observable
final class ProfileViewModel: ObservableObject {
    var isEditingName = false
    var currentName = ""
    var profileName: String? = UserDefaults.standard.string(forKey: "profileName")
    
    var isEditingImage = false
    var profileImage: String? = UserDefaults.standard.string(forKey: "profileImage")
    var selectedImage: String? = UserDefaults.standard.string(forKey: "profileImage")
    
    var showAlert = false
    
    var images = [
        "avatar 1", "avatar 2", "avatar 3", "avatar 4", "avatar 5", "avatar 6", "avatar 7", "avatar 8", "avatar 9", "avatar 10"
    ]
    
    var presentGoal = false
    var caloriesGoal: Int = UserDefaults.standard.value(forKey: "caloriesGoal") as? Int ?? 900
    var stepGoal: Int = UserDefaults.standard.value(forKey: "stepGoal") as? Int ?? 7500
    var activeGoal: Int = UserDefaults.standard.value(forKey: "activeGoal") as? Int ?? 60
    var standGoal: Int = UserDefaults.standard.value(forKey: "standGoal") as? Int ?? 12
    var sleepGoal: Int = UserDefaults.standard.value(forKey: "sleepGoal") as? Int ?? 8
    var weightGoal: Double = UserDefaults.standard.value(forKey: "weightGoal") as? Double ?? 70.0
    
    func presentEditName() {
        isEditingName = true
        isEditingImage = false
    }
    
    func presentEditImage() {
        isEditingName = false
        isEditingImage = true
    }
    
    func dismissEdit() {
        isEditingName = false
        isEditingImage = false
    }
    
    func setNewName() {
        if !currentName.isEmpty {
            profileName = currentName
            UserDefaults.standard.setValue(currentName, forKey: "profileName")
            self.dismissEdit()
        }
    }
    
    func didSelectNewImage(name: String) {
        selectedImage = name
    }
    
    func setNewImage() {
        profileImage = selectedImage
        UserDefaults.standard.setValue(selectedImage, forKey: "profileImage")
        self.dismissEdit()
    }
    
    @Published var notificationsEnabled: Bool = UserDefaults.standard.bool(forKey: "notificationsEnabled") {
            didSet {
                UserDefaults.standard.set(notificationsEnabled, forKey: "notificationsEnabled")
                handleNotificationToggle()
            }
        }
    
    @MainActor
    func presentEmailApp() {
        let emailSubject = "Fitness App - Contact Us"
        let emailRecipient = "go.imam.uni@gmail.com"
        
        let encodedSubject = emailSubject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let encodedRecipient = emailRecipient.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        let urlString = "mailto:\(encodedRecipient)?subject=\(encodedSubject)"
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.showAlert = true
            }
        }
    }
    
    func saveUserGoals() {
        UserDefaults.standard.set(stepGoal, forKey: "stepGoal")
        UserDefaults.standard.set(caloriesGoal, forKey: "caloriesGoal")
        UserDefaults.standard.set(activeGoal, forKey: "activeGoal")
        UserDefaults.standard.set(standGoal, forKey: "standGoal")
        UserDefaults.standard.set(sleepGoal, forKey: "sleepGoal")
        UserDefaults.standard.set(weightGoal, forKey: "weightGoal")
        presentGoal = false
    }
    
        @Published var isUserLoggedIn: Bool = UserDefaults.standard.bool(forKey: "isUserLoggedIn")

        // Handle toggle for notifications
        private func handleNotificationToggle() {
            if notificationsEnabled {
                NotificationManager.shared.scheduleWorkoutReminders()
                NotificationManager.shared.scheduleAffirmationNotifications()
            } else {
                NotificationManager.shared.disableAllNotifications()
            }
        }

        // Handle login action
        func loginUser(email: String, password: String) {
            // Replace with actual login logic (e.g., Firebase Auth)
            if email == "test@example.com" && password == "password" {
                isUserLoggedIn = true
                UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
            } else {
                // Handle login failure
                isUserLoggedIn = false
            }
        }

        // Handle logout action
        func logoutUser() {
            isUserLoggedIn = false
            UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
            // Additional cleanup if necessary
        }

        // Handle registration action
        func registerUser(email: String, password: String) {
            // Replace with actual registration logic (e.g., Firebase Auth)
            // Simulate successful registration
            isUserLoggedIn = true
            UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
        }
    }
