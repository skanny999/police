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
    case crime, police, none
}


class MapViewModel: NSObject {
    
    private var mapView: MKMapView!
    
    private var mapMode: Mode = .none
    private let locationManager = CLLocationManager()
    private var location: CLLocation?

    init(with mapview: MKMapView) {
        
        super.init()
        mapView = mapview
        mapView.delegate = self
        permissionForLocation()
        
    }
}

extension MapViewModel: MapViewControllerDelegate {
    
    func mapViewController(_ mapViewController: MapViewController, didTapButtonForMode mode: Mode) {
        
        switch mode {
        case .crime:
            print(mode)
            findCrimes()
        case .police:
            print(mode)
            // make call for police
        case .none:
            break
        }
    }
    
    
    func findCrimes() {
        
        let mapViewRect = mapView.visibleMapRect
        
        NetworkProvider.getRequest(forUrl: URLFactory.urlForCrimesByArea(mapViewRect)) { (data, error) in
            if let data = data {
            UpdateProcessor.updateObjects(ofType: Crime.self, fromData: data, completion: { [weak self] (updated) in
                
                let crimes = CoreDataManager.shared().allCrimes()
                
                if let mapview = self?.mapView {
                    
                    DispatchQueue.main.async {
                        mapview.removeAnnotations(mapview.annotations)
                        
                        for crime in crimes {
                            
                            if CLLocationCoordinate2DIsValid(crime.coordinate) {
                                
//                                let mock = Mock(withCoordinate: crime.coordinate)
                                
                                mapview.addAnnotation(crime)
                            }
                            
                        }
                    }
                    
//                    mapview.removeAnnotations(mapview.annotations)
//
//                    mapview.addAnnotations(crimes as [MKAnnotation])
                    
//                    for crime in crimes {
//                        print(crime.categoryCode!)
//                        let annotation = MKPointAnnotation()
//                        annotation.coordinate = crime.coordinate
//                        annotation.title = crime.categoryCode
//                        mapview.addAnnotation(annotation)
//                    }
                }
            })
        }
        }
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
                let responceLocation = CLLocation(latitude: response.boundingRegion.center.latitude, longitude: response.boundingRegion.center.longitude)
                self?.location = responceLocation
                self?.zoom(into: responceLocation)
            }
        }
    }
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        

    }

    func zoom(into location: CLLocation) {
        
        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if !annotation.isKind(of: MKUserLocation.self) {
            
            return annotationView(for: annotation)
            
//            let reuseId = "pin"
//            var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
//            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
//            pinView?.canShowCallout = true
            
//            return pinView
        }
         return nil
    }
    
    func annotationView(for annotation: MKAnnotation) -> MKAnnotationView {
        
        let identifier = "truck"
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        
        return annotationView.view(forAnnotation:annotation)
    }

}

extension MapViewModel: SearchResultsDelegate {
    
    func searchResultsController(_ sec: SearchResultsController, didSelectLocation description: String) {
        
        findMapItems(with: description)
    }
}

extension MapViewModel: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
            
            zoom(into: location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print(error)
        //deal with error
    }
    
    
    private func permissionForLocation() {
        
        locationManager.delegate = self
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





