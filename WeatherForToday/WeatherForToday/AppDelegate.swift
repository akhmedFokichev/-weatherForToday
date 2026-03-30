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
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let vc = MainScreenBuilder.build()
        
        let nc = UINavigationController(rootViewController: vc)
        nc.setNavigationBarHidden(true, animated: false)
        
        window?.rootViewController = nc
        window?.makeKeyAndVisible()
        
        return true
    }

}
