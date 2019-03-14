//
//  MapViewModel.swift
//  Police
//
//  Created by Riccardo Scanavacca on 12/03/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import Foundation
import UIKit
import MapKit

enum Mode {
    case criminal, police, none
}


class MapViewModel: NSObject {
    
    var mapMode: Mode = .none
    let locationManager = CLLocationManager()
    var mapItems: [MKMapItem] = []
    var tableview: UITableView?
    
    
    override init() {
        super.init()
        setDelegates()
        permissionForLocation()
    }
    
    private func setDelegates() {
        locationManager.delegate = self
    }

}



extension MapViewModel: MKMapViewDelegate {
    
    
    private func findLocations(with text: String) {
        
        findMapItems(with: text)
    }
    
    private func findMapItems(with text: String) {
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = text
        let search = MKLocalSearch(request: request)
        
        search.start {  [weak self] (response, error) in
    
            if let response = response {
                self?.mapItems = response.mapItems
            }
        }
    }
}

extension MapViewModel: SearchResultsDelegate {
    func searchResultsController(_ sec: SearchResultsController, didSelectLocation description: String) {
        
        findMapItems(with: description)
    }
}

extension MapViewModel: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //zoom in
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print(error)
        //deal with error
    }
    
    
    private func permissionForLocation() {
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        case .restricted, .denied:
            return
        }
    }
}





