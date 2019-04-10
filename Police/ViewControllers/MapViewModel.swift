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
    
    var mapMode: Mode = .none
    private let locationManager = CLLocationManager()
    private var location: CLLocation?
    private var initialLocation: CLLocation?
    private var currentlyShownAnnotations: [Annotable] = []
    private var mapPolygon: MKPolygon?
    
    
    // MARK: - View updater variables
    var selecteNeighbourhoodDidChange: ((String?) -> Void)?
    var dataIsLoading: ((Bool) -> Void)?
    
    private var isShowingNeighbourhood: Bool {
        return mapView.overlays.count > 0
    }
    
    var networkCallsCounter: Int = 0 {
        didSet{
            let isLoading = networkCallsCounter > 0
            print(isLoading ? "data is loading:\(networkCallsCounter)" : "data has finished loading \(networkCallsCounter)")
            dataIsLoading?(networkCallsCounter > 0)
        }
    }

    init(with mapview: MKMapView) {
        
        super.init()
        mapView = mapview
        mapView.delegate = self
        permissionForLocation()
        positionMapNearUser()
        mapView.showsUserLocation = false
        registerAnnotationViewClass()
    }
    
    
    private var selectedNeighbourhood: String? {
        didSet {
            selecteNeighbourhoodDidChange?(selectedNeighbourhood)
        }
    }
    
    private func registerAnnotationViewClass() {
        
        mapView.register(CrimeAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.register(ClusterAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
    }
}

extension MapViewModel: MapViewControllerDelegate {
    
    func mapViewController(_ mapViewController: MapViewController, didTapMapWith sender: UITapGestureRecognizer) {
        
        let selectedPoint = sender.location(in: mapView)

        if thereIsAnAnnotation(on: selectedPoint) {
            return
        }
        
        if isShowingNeighbourhood {
            mapView.removeOverlays(mapView.overlays)
            selectedNeighbourhood = nil
            retrieveData()
        } else {
            let location = mapView.convert(selectedPoint, toCoordinateFrom: mapView)
            fetchNeighbourhood(forLocation: location)
        }
    }


    
    func mapViewController(_ mapViewController: MapViewController, didTapButtonForMode mode: Mode) {
        
        mapMode = mode
        resetAnnotations()
        retrieveData()
        dataIsLoading?(networkCallsCounter > 0)
    }
    
    
    private func thereIsAnAnnotation(on location: CGPoint) -> Bool {
        
        var isAnnotation = false
        for annotation in mapView.annotations {
            if let annotationView = mapView.view(for: annotation), annotationView.frame.contains(location) {
                isAnnotation = true
            }
        }
        return isAnnotation
    }
    
    private func resetAnnotations() {
        
        currentlyShownAnnotations = []
        mapView.removeAnnotations(mapView.annotations)
        mapPolygon = nil
    }

    
    private var viewIsZoomedIn: Bool {
        
        if mapView.zoomLevel > 300 {
            print("zoom closer to retrieve data")
            return false
        }

        if let existingPoligon = mapPolygon, existingPoligon.intersects(mapView.visibleMapRect) {
            
            mapPolygon = existingPoligon.merge(with: mapView.visibleRectPolygon)
            return !MKMapRectEqualToRect(existingPoligon.boundingMapRect, mapPolygon!.boundingMapRect)
            
        } else {
            
            mapPolygon = mapView.visibleRectPolygon
            return true
        }
    }
    
    
    
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        if !isShowingNeighbourhood {
            retrieveData()
        }
    }
    

    
    private func displayAnnotations(_ annotations: [Annotable]) {

        DispatchQueue.main.async {

            self.mapView.addAnnotations(annotations)
            self.currentlyShownAnnotations.append(contentsOf: annotations)
            
            if self.isShowingNeighbourhood {
                if let polygon = self.mapView.overlays.first as? MKPolygon {
                    self.removeAnnotation(outside: polygon)
                }
            }
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
        if viewIsZoomedIn {
            getNewCrimes()
        } else {
            print("data already downloaded")
        }
    }
    
    func fetchSavedCrimes() {
        
        if mapMode != .crime { return }
        
        if let crimes = CoreDataProvider.crimesWithin(mapViewArea: mapView.visibleMapRect, excluding: currentlyShownAnnotations) {
            displayAnnotations(crimes)
        }
    }
    
    func getNewCrimes() {
        
        if let existingPoligon = mapPolygon, existingPoligon.intersects(mapView.visibleMapRect) {
            
            let tempMapPolygon = existingPoligon.merge(with: mapView.visibleRectPolygon)
            if !MKMapRectEqualToRect(existingPoligon.boundingMapRect, tempMapPolygon.boundingMapRect) {
                
                print("Retrieving data")
                networkCallsCounter += 1
                UpdateManager.updateCrimes(within: mapView.visibleMapRect) { [weak self] (error) in
                    if error != nil {
                        print("Error updating crimes from beckend: \(error.debugDescription)")
                    } else {
                        self?.fetchSavedCrimes()
                        self?.mapPolygon = tempMapPolygon
                        print("data retrieved")
                    }
                    self?.networkCallsCounter -= 1
                }
            }

        } else {
            
            mapPolygon = mapView.visibleRectPolygon
            
            print("Retrieving data")
            networkCallsCounter += 1
            UpdateManager.updateCrimes(within: mapView.visibleMapRect) { [weak self] (error) in
                if error != nil {
                    print("Error updating crimes from beckend: \(error.debugDescription)")
                } else {
                    self?.fetchSavedCrimes()
                    print("data retrieved")
                }
                self?.networkCallsCounter -= 1
            }
            
            
        }
    }
    
    // MARK: - Police
    
    func displayPolice() {
        
        fetchSavedStopAndSearch()
        getNewStopAndSearch()
    }
    
    func fetchSavedStopAndSearch() {
        
        if mapMode != .police { return }
        
        if let sas = CoreDataProvider.stopAndSearch(mapViewArea: mapView.visibleMapRect, excluding: currentlyShownAnnotations) {
            displayAnnotations(sas)
        }
    }
    
    func getNewStopAndSearch() {
        
        networkCallsCounter += 1
        UpdateManager.updateStopAndSearch(within: mapView.visibleMapRect) { [weak self] (error) in
            if error != nil {
                print("Error updating crimes from beckend: \(error.debugDescription)")
            } else {
                self?.fetchSavedStopAndSearch()
            }
            self?.networkCallsCounter -= 1
        }
    }
    
    // MARK: - Neighbourhood
    
    func fetchNeighbourhood(forLocation location: CLLocationCoordinate2D) {
        
        UpdateManager.updateNeighbourhood(withLocation: location) { [weak self] (error, neighbouhood) in
            
            if let error = error {
                print(error)
            } else if let neighbourood = neighbouhood {
                
                DispatchQueue.main.async {
                    self?.showNeighbourhood(neighbourood)
                }
            } else {
                print("couldn't process neighbourood")
            }
        }
    }
    
    func showNeighbourhood(_ neighbourood: Neighbourhood) {
        
        if let polygon = neighbourood.polygonData?.polygon {
            mapView.addOverlay(polygon)
            selectedNeighbourhood = neighbourood.name
            retrieveData()
        }
    }
    
    func removeAnnotation(outside polygon: MKPolygon) {
        
        let toRemove = currentlyShownAnnotations.filter { !polygon.contains(point: $0.coordinate)}
        currentlyShownAnnotations = currentlyShownAnnotations.filter { polygon.contains(point: $0.coordinate)}
        mapView.removeAnnotations(toRemove)
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


    private func setMapLocation(_ location: CLLocation, animated: Bool) {
        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        mapView.setRegion(region, animated: animated)
    }
    
    func zoom(into location: CLLocation) {
        
        setMapLocation(location, animated: true)
    }
    
    func positionMapNearUser() {
        
        if let locationDict = UserDefaults.standard.object(forKey: "LAST_LOCATION") as? [String: CLLocationDegrees],
            let location = locationDict.location {
            initialLocation = location
            setMapLocation(location, animated: false)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation.conforms(to: Annotable.self)  {
            
            return CrimeAnnotationView(annotation: annotation as! Annotable, reuseIdentifier: CrimeAnnotationView.reuseID)
        }
         return nil
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        if let overlay = overlay as? MKPolygon {

            let renderer = MKPolygonRenderer(polygon: overlay)
            renderer.fillColor = UIColor.black.withAlphaComponent(0.2)
            renderer.strokeColor = .blue
            renderer.lineWidth = 1
            
            DispatchQueue.main.async {
                mapView.setVisibleMapRect(overlay.boundingMapRect,
                                          edgePadding: UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0),
                                          animated: true)
            }

            return renderer
        }
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
        
        if initialLocation != nil { return }
        
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






