//
//  AppDelegate.swift
//  VKMessenger
//
//  Created by Егор on 14.01.2018.
//  Copyright © 2018 Егор. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        VKMAuthService.sharedInstance.process(url: url, options: options)
        return true
    }
    

}

