//
//  AppDelegate.swift
//  POC Account
//
//  Created by Christopher San Diego on 12/6/19.
//  Copyright © 2019 Christopher San Diego. All rights reserved.
//

import Cleanse
import GRPC
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = try! ComponentFactory.of(AppComponent.self).build(())
        window.makeKeyAndVisible()
        self.window = window
        return true
    }

}

