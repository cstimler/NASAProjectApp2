//
//  AppDelegate.swift
//  NasaProjectApp
//
//  Created by June2020 on 5/24/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    // Reference: https://stackoverflow.com/questions/36358032/override-app-orientation-setting/48120684#48120684
    // for below 5 lines: (with some modifications) to control orientation in individual view controller
    
    var autoRotation: Bool = true

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return autoRotation ? .allButUpsideDown : .portrait
      }


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

