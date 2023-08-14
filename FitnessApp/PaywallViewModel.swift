//
//  PaywallViewModel.swift
//  FitnessApp
//
//  Created by Jason Dubon on 8/12/23.
//

import Foundation
import RevenueCat

class PaywallViewModel: ObservableObject {
    
    @Published var currentOffering: Offering?
    
    init() {
        Purchases.shared.getOfferings { (offerings, error) in
            if let offering = offerings?.current {
                
                DispatchQueue.main.async {
                    self.currentOffering = offering
                }
            }
        }
    }
}
