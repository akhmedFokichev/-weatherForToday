//
//  AppDelegate.swift
//  WeatherForToday
//
//  Created by Azapsh on 30.03.2026.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private let di = AppDI.shared

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = .orange
        di.configure(window: window)
        di.navigationService?.setRoot(
            LaunchScreenBuilder.build(di: di),
            embeddedInNavigation: false,
            animated: false
        )
        self.window = window
        return true
    }
}

