//
//  FitnessAppApp.swift
//  FitnessApp
//
//  Created by Jason Dubon on 7/29/23.
//

import SwiftUI
import RevenueCat

@main
struct FitnessAppApp: App {
    
    init() {
        Purchases.logLevel = .debug
        Purchases.configure(withAPIKey: "appl_OiZLcmUmVWNwiitRslmiiogTxFn")
    }
    
    var body: some Scene {
        WindowGroup {
            FitnessTabView()
        }
    }
}
