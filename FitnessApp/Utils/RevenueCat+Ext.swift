//
//  RevenueCat+Ext.swift
//  FitnessApp
//
//  Created by Jason Dubon on 8/12/23.
//

import RevenueCat

extension SubscriptionPeriod {
    var durationTitle: String {
        switch self.unit {
        case .day: return "Daily"
        case .week: return "Weekly"
        case .month: return "Monthly"
        case .year: return "Annual"
        @unknown default: return "Unknown"
        }
    }
}
