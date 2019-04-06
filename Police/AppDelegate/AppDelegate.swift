//
//  AppDelegate.swift
//  Police
//
//  Created by Riccardo on 17/01/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var currentLocation: CLLocation?
    var locationManager = CLLocationManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if !AppStatus.isTesting { //avoid loading the persistant container more than once which causes crashes
            UpdateManager.updatePeriods()
        }
        
        configureLocationManager()
      
        return true
    }


    func applicationWillTerminate(_ application: UIApplication) {
        
        saveCurrentLocation()
        CoreDataManager.shared.save()
    }
    
    func saveCurrentLocation() {
        
        guard let latitude = currentLocation?.coordinate.latitude,
            let longitude = currentLocation?.coordinate.longitude  else { return }
        
        let locationDict = ["latitude": latitude,
                            "longitude": longitude]
        
        UserDefaults.standard.set(locationDict, forKey: "LAST_LOCATION")
    }
}

extension AppDelegate: CLLocationManagerDelegate {
    
    private func configureLocationManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last {
            currentLocation = location
        }
    }
}

