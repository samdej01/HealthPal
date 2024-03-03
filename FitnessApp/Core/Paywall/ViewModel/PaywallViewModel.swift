//
//  PaywallViewModel.swift
//  FitnessApp
//
//  Created by Jason Dubon on 8/12/23.
//

import Foundation
import RevenueCat

@Observable
final class PaywallViewModel {
    
    var currentOffering: Offering?
    
    init() {
        Purchases.shared.getOfferings { (offerings, error) in
            if let offering = offerings?.current {
                
                DispatchQueue.main.async {
                    self.currentOffering = offering
                }
            }
        }
    }
    
    func purchase(package: Package) async throws {
        let result = try await Purchases.shared.purchase(package: package)
        if result.customerInfo.entitlements["premium"]?.isActive != true {
            throw URLError(.badURL)
        }
    }
    
    func restorePurchases() async throws {
        let customerInfo = try await Purchases.shared.restorePurchases()
        if customerInfo.entitlements["premium"]?.isActive != true {
            throw URLError(.badURL)
        }
    }
}
