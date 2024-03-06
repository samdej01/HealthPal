//
//  TabState.swift
//  FitnessApp
//
//  Created by Jason Dubon on 3/2/24.
//

import Foundation
import RevenueCat

enum FitnessTabs: String {
    case home = "Home"
    case charts = "Charts"
    case leaderboard = "Leaderboard"
    case profile = "Profile"
}

@Observable
final class FitnessTabState {
    
    var selectedTab = "Home"
    var isPremium = false
    var showTerms = true
    
    init(selectedTab: String = "Home", isPremium: Bool = false, showTerms: Bool = true) {
        self.selectedTab = selectedTab
        self.isPremium = isPremium
        self.showTerms = UserDefaults.standard.string(forKey: "username") == nil
        
        checkSubscriptionStatus()
    }
    
    func checkSubscriptionStatus() {
        Purchases.shared.getCustomerInfo { [weak self] customerInfo, error in
            self?.isPremium = customerInfo?.entitlements["premium"]?.isActive == true
        }
    }
}
