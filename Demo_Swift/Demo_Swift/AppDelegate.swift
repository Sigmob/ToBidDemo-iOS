//
//  AppDelegate.swift
//  Demo_Swift
//
//  Created by Codi on 2025/7/28.
//

import UIKit
import DoraemonKit


@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        LogUtil.loggerInit()
        navigationInit()
        AppUtil.setUpSlotIds()
        SDKInitialize.shared.setup()
        return true
    }
    
    func navigationInit() {
        let mainColor = UIColor(red: 242/255.0, green: 105/255.0, blue: 11/255.0, alpha: 1)
        if #available(iOS 13.0, *) {
            let app = UINavigationBarAppearance()
            app.configureWithOpaqueBackground()
            app.backgroundColor = mainColor
            app.titleTextAttributes = [
                .foregroundColor: UIColor.white
            ]
            UINavigationBar.appearance().scrollEdgeAppearance = app
            UINavigationBar.appearance().standardAppearance = app
            UINavigationBar.appearance().tintColor = .white
        } else {
            let app = UINavigationBar.appearance()
            app.tintColor = .white
            app.barTintColor = mainColor
            app.titleTextAttributes = [
                .foregroundColor: UIColor.white
            ]
        }
    }
    
    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

