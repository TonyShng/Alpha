//
//  AppDelegate.swift
//  AlphaProject
//
//  Created by a on 2022/7/23.
//

import UIKit

// swiftlint:disable force_cast
let appDelegate = UIApplication.shared.delegate as! AppDelegate
// swiftlint:enable force_cast

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window!.backgroundColor = .white
        self.window!.makeKeyAndVisible()
        
        self.window!.rootViewController = BaseNavigationController(rootViewController: MainViewController())
        return true
    }
}
