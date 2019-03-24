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
    private var shouldRefreshData = false
    private var mapAnnotations: [Annotation] = []
    private var lastZoomLevel: Int = 100000

    init(with mapview: MKMapView) {
        
        super.init()
        mapView = mapview
        mapView.delegate = self
        permissionForLocation()
        registerAnnotationViewClass()
    }
    
    private func registerAnnotationViewClass() {
        
        mapView.register(CrimeAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.register(ClusterAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
    }
}

extension MapViewModel: MapViewControllerDelegate {
    
    func mapViewController(_ mapViewController: MapViewController, didTapMapWith sender: UITapGestureRecognizer) {
        
        let location = sender.location(in: mapView)
        
        if !isAnnotation(location) {
            
            retrieveData()
        }
    }
    
    private func isAnnotation(_ location: CGPoint) -> Bool {
        
        var isAnnotation = false
        for annotation in mapView.annotations {
            if let annotationView = mapView.view(for: annotation), annotationView.frame.contains(location) {
                isAnnotation = true
            }
        }
        return isAnnotation
    }
    
    
    func mapViewController(_ mapViewController: MapViewController, didTapButtonForMode mode: Mode) {
        
        mapMode = mode
        retrieveData()
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        if mapView.zoomLevel >= lastZoomLevel {
            retrieveData()
        }
        lastZoomLevel = mapView.zoomLevel

    }

    
    private func displayAnnotations(_ annotables: [Annotable]) {

        DispatchQueue.main.async {
            let annotations = annotables.map { Annotation(with: $0) }
            
//            self.mapView.removeAnnotations(self.mapView.annotations)
            self.mapView.addAnnotations(annotations)
            self.mapAnnotations.append(contentsOf: annotations)

            print("Annotations refreshed")
        }
    }
}

// MARK: - Data Provider

private extension MapViewModel {
    
    func retrieveData() {
        
        switch mapMode {
        case .crime:
            fetchSavedCrimes()
            findNewCrimes()
        case .police:
            print(mapMode)
        // make call for police
        case .none:
            break
        }
        
    }

    
    func fetchSavedCrimes() {

        if let crimes = CoreDataProvider.crimesWithin(mapView: mapView, excluding: mapAnnotations) {
            displayAnnotations(crimes)
        }
    }
    
    func findNewCrimes() {
        
        NetworkProvider.getRequest(forUrl: URLFactory.urlForCrimesByArea(mapView.visibleMapRect)) { (data, error) in
            
            if let error = error {
                print(error.debugDescription)
                return
            }
            
            if let data = data {
                
                UpdateProcessor.updateObjects(ofType: Crime.self, fromData: data, completion: { [weak self] (updated) in
                    print("objects updated :\(Date())")
                    if updated {
                        self?.fetchSavedCrimes()
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
    
//    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
//
//        waitForViewToSettle {[weak self] in
//            print("retrieving data: \(Date())")
//            self?.retrieveData()
//        }
//    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        retrieveData()
    }
    



    func zoom(into location: CLLocation) {
        
        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation.conforms(to: Annotable.self)  {
            
            return CrimeAnnotationView(annotation: annotation as! Annotable, reuseIdentifier: CrimeAnnotationView.reuseID)
        }
         return nil
    }
    
    func waitForViewToSettle(completion: @escaping () -> Void ) {
        shouldRefreshData = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if self.shouldRefreshData {
                completion()
                self.shouldRefreshData = false
            }
        }
        shouldRefreshData = true
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

//extension MapViewModel {
//
//    private func updatedAnnotations(from annotables: [Annotable]) -> (toBeAdded: [Annotation], toBeRemoved: [Annotation]) {
//
//        var annotationsToAdd: [Annotable] = []
//        var commonAnnotations: [Annotable] = []
//        var annotationsToRemove: [Annotable] = []

//        if let currentlyVisibleAnnotations = visibleAnnotations {
//
//            for newAnnotation in annotables {
//
//                if currentlyVisibleAnnotations.contains(where: {$0 === newAnnotation} ) {
////                    commonAnnotations.append(newAnnotation)
//                } else {
//                    annotationsToAdd.append(newAnnotation)
//                }
//            }
//
//            for annotation in currentlyVisibleAnnotations {
//
//                if !annotables.contains(where: {$0 === annotation}) {
//                    annotationsToRemove.append(annotation)
//                }
//            }
//
//            for annotation in currentlyVisibleAnnotations {
//
//                annotationsToRemove = currentlyVisibleAnnotations.filter {_ in
//                    !commonAnnotations.contains(where: { $0 === annotation })
//                }
//            }
            
//        } else {
//            annotationsToAdd = annotables
////        }
//
//        return (annotationsToAdd.map { Annotation(with: $0)}, annotables.map { Annotation(with: $0)} )
//    }
//}





