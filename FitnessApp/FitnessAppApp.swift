//
//  FitnessAppApp.swift
//  FitnessApp
//
//  Created by Jason Dubon on 7/29/23.
//

import SwiftUI
import RevenueCat
import FirebaseCore

@main
struct FitnessAppApp: App {

    init() {
        // Revenue Cat Setup
        Purchases.logLevel = .debug
        Purchases.configure(withAPIKey: "appl_OiZLcmUmVWNwiitRslmiiogTxFn")
        
        // Firebase Setup
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            FitnessTabView()
        }
    }
}
