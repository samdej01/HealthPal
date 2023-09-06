//
//  FitnessAppApp.swift
//  FitnessApp
//
//  Created by Jason Dubon on 7/29/23.
//

import SwiftUI
import RevenueCat
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct FitnessAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
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

// MARK: Present an alert from anywhere in your app
func presentAlert(title: String, message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let ok = UIAlertAction(title: "Ok", style: .default)
    alert.addAction(ok)
    rootController?.present(alert, animated: true)
}

var rootController: UIViewController? {
    var root = UIApplication.shared.windows.first?.rootViewController
    if let presenter = root?.presentedViewController {
        root = presenter
    }
    return root
}
