import Foundation
import RevenueCat

enum FitnessTabs: String, CaseIterable {
    case home = "Home"
    case charts = "Charts"
    case leaderboard = "Leaderboard"
    case profile = "Profile"
    case plans = "Plans"
}

final class FitnessTabState: ObservableObject {
    @Published var selectedTab: FitnessTabs = .home
    @Published var isPremium = false
    @Published var showTerms = true
    
    init(selectedTab: FitnessTabs = .home, isPremium: Bool = false, showTerms: Bool = true) {
        self.selectedTab = selectedTab
        self.isPremium = isPremium
        self.showTerms = UserDefaults.standard.string(forKey: "username") == nil
        
        checkSubscriptionStatus()
    }
    
    func checkSubscriptionStatus() {
        Purchases.shared.getCustomerInfo { [weak self] customerInfo, error in
            DispatchQueue.main.async {
                self?.isPremium = customerInfo?.entitlements["premium"]?.isActive == true
            }
        }
    }
}
