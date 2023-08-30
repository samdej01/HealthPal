//
//  Double+Ext.swift
//  FitnessApp
//
//  Created by Jason Dubon on 8/23/23.
//

import Foundation

extension Double {
    
    func formattedNumberString() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        
        return formatter.string(from: NSNumber(value: self)) ?? "0"
    }
    
}