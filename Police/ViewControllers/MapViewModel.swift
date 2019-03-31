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
    private var currentlyShownAnnotations: [Annotable] = []
    
    //testing polygon
    private var mapPolygon: MKPolygon?

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
    
    func mapViewController(_ mapViewController: MapViewController, didTapButtonForMode mode: Mode) {
        
        mapMode = mode
        retrieveData()

    }
    
    // testing polygons
    
    private func shouldUpdateData() -> Bool {
        
        var shouldReload = true

        if let existingPoligon = mapPolygon, existingPoligon.intersects(mapView.visibleMapRect) {
            
            mapPolygon = existingPoligon.merge(with: mapView.visibleRectPolygon)
            shouldReload = !MKMapRectEqualToRect(existingPoligon.boundingMapRect, mapPolygon!.boundingMapRect)
            
        } else {
            
            mapPolygon = mapView.visibleRectPolygon
        }

        return shouldReload
    }
    
    
    
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        retrieveData()

    }
    

    
    private func displayAnnotations(_ annotations: [Annotable]) {

        DispatchQueue.main.async {

            self.mapView.addAnnotations(annotations)
            self.currentlyShownAnnotations.append(contentsOf: annotations)
        }
    }
}

// MARK: - Data Provider

private extension MapViewModel {
    
    func retrieveData() {
        
        switch mapMode {
        case .crime:
            displayCrimes()
        case .police:
            displayPolice()
        case .none:
            break
        }
    }
    
    // MARK: - Crime

    func displayCrimes() {
        fetchSavedCrimes()
        if shouldUpdateData() {
            getNewCrimes()
        }
    }
    
    func fetchSavedCrimes() {
        
        if let crimes = CoreDataProvider.crimesWithin(mapViewArea: mapView.visibleMapRect, excluding: currentlyShownAnnotations) {
            displayAnnotations(crimes)
        }
    }
    
    func getNewCrimes() {
        
        UpdateManager.updateCrimes(within: mapView.visibleMapRect) { [weak self] (error) in
            if error != nil {
                print("Error updating crimes from beckend: \(error.debugDescription)")
            } else {
                self?.fetchSavedCrimes()
            }
        }
    }
    
    // MARK: - Police
    
    func displayPolice() {
        
        fetchSavedStopAndSearch()
        getNewStopAndSearch()
        fetchSavedNeighbourhood()
    }
    
    func fetchSavedStopAndSearch() {
        
        if let sas = CoreDataProvider.stopAndSearch(mapViewArea: mapView.visibleMapRect, excluding: currentlyShownAnnotations) {
            displayAnnotations(sas)
        }
        
    }
    
    func getNewStopAndSearch() {
        
        UpdateManager.updateStopAndSearch(within: mapView.visibleMapRect) { [weak self] (error) in
            if error != nil {
                print("Error updating crimes from beckend: \(error.debugDescription)")
            } else {
                self?.fetchSavedStopAndSearch()
            }
        }
    }
    
    func fetchSavedNeighbourhood() {
        
        
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
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
//        if let overlay = overlay as? MKPolygon {
//
//            let renderer = MKPolygonRenderer(polygon: overlay)
//            renderer.fillColor = UIColor.black.withAlphaComponent(0.5)
//            renderer.strokeColor = .orange
//            renderer.lineWidth = 2
//            return renderer
//        }
        return MKOverlayRenderer()
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
            break
            @unknown default:
                fatalError()
        }
    }
}






