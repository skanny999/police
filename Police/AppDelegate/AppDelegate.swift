//
//  AppDelegate.swift
//  Police
//
//  Created by Riccardo on 17/01/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }


    func applicationWillTerminate(_ application: UIApplication) {

        CoreDataManager.shared().saveContext()
    }




}

