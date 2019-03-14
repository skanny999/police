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
    var searchCompleter = MKLocalSearchCompleter()
    var mapItems: [MKMapItem] = []
    var searchResults: [MKLocalSearchCompletion] = []
    var tableview: UITableView?
    
    
    override init() {
        super.init()
        setDelegates()
        permissionForLocation()
        configureSearchCompleter()
    }
    
    private func setDelegates() {
        locationManager.delegate = self
        searchCompleter.delegate = self
    }
    
    private func configureSearchCompleter() {
        
        searchCompleter.filterType = .locationsOnly
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
        
        search.start { (response, error) in
            
            if let response = response {
                
                print(response.mapItems)
            }
        }
    }
}


extension MapViewModel: UISearchResultsUpdating, MKLocalSearchCompleterDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            searchCompleter.queryFragment = searchText
        }
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        
        searchResults = completer.results
        tableview?.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        
        print(error)
    }
}

extension MapViewModel: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        searchCompleter.region = MKCoordinateRegion(center: locations.first!.coordinate, latitudinalMeters: 1000000, longitudinalMeters: 1000000)
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





