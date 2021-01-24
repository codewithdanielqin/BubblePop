//
//  AppDelegate.swift
//  BubblePop
//
//  Created by XuanZhi Qin on 2021/1/16.
//  Copyright © 2021 XuanZhi Qin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Look for initial settings. e.g. 'timer' is nil, initialize game settings
        if UserDefaults.standard.value(forKey: "player") == nil {
            // If no initial settinsg were found, reset it
            AppDelegate.initialiseSettings()
        }
        
        return true
    }
    
    /// Initialize Game Settings, 60s for timer, 15 for max bubbles
    static func initialiseSettings() {
        let userDefaults = UserDefaults.standard
        userDefaults.set(60, forKey: "timer")
        userDefaults.set(15, forKey: "bubbles")
        userDefaults.set("Daniel Qin", forKey: "player")
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

