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
    
    // MARK: - View updater variables
    
    var mapMode: Mode = .none
    var selecteNeighbourhoodDidChange: ((String?) -> Void)?
    var dataIsLoading: ((Bool) -> Void)?
    var hideDetails: (() -> Void)?
    var showDetails: (() -> Void)?
    
    var presenter: UINavigationController!
    var detailsViewController: SelectionDetailsViewController! {
        return presenter.viewControllers.first as? SelectionDetailsViewController
    }
    
    // MARK: - Private properties
    
    private var mapView: MKMapView!
    private let locationManager = CLLocationManager()
    private var location: CLLocation?
    private var initialLocation: CLLocation?
    private var currentlyShownAnnotations: [Annotable] = []
    private var mapPolygon: MKPolygon?
    private var networkCallsCounter: Int = 0 {
        didSet{
            dataIsLoading?(networkCallsCounter > 0)
        }
    }
    
    // MARK: - Computed Variables
    
    private var isShowingNeighbourhood: Bool {
        
        return mapView.overlays.count > 0
    }
    
    private var viewIsZoomedIn: Bool {
        
        if mapView.zoomLevel > 300 {
            print("zoom closer to retrieve data")
            return false
        }
        return true
    }
    
    // MARK: - Setup

    init(with mapview: MKMapView) {
        
        super.init()
        mapView = mapview
        mapView.delegate = self
        permissionForLocation()
        positionMapNearUser()
        mapView.showsUserLocation = false
        registerAnnotationViewClass()
    }
    
    private func registerAnnotationViewClass() {
        
        mapView.register(CrimeAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.register(ClusterAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
    }
    
    func setPresenter(_ navigationController: UINavigationController) {
        presenter = navigationController
        detailsViewController.delegate = self
        detailsViewController.viewModel = nil
    }
}


extension MapViewModel: Dismissable {
    
    func dismiss(_ viewController: SelectionDetailsViewController) {
        hideDetails?()
    }
}

extension MapViewModel: MapViewControllerDelegate {
    
    // MapView Controller Delegate
    
    func mapViewController(_ mapViewController: MapViewController, didTapMapWith sender: UITapGestureRecognizer) {
        
        let selectedPoint = sender.location(in: mapView)

        if thereIsAnAnnotation(on: selectedPoint) {
            return
        }
        
        if isShowingNeighbourhood {
            mapView.removeOverlays(mapView.overlays)
            selecteNeighbourhoodDidChange?(nil)
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
    
    // MARK: - Annotations
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        guard let annotation = view.annotation else { return }
        
        if let annotations = view.annotation as? MKClusterAnnotation {
            showDetailsForAnnotations(annotations)
        } else  {
            showDetailsForSingleAnnotation(annotation)
        }
    }
    
    fileprivate func showDetailsForAnnotations(_ annotations: MKClusterAnnotation) {
        if let crimes = annotations.memberAnnotations as? [Crime] {
            showDetails(for: crimes)
        } else if let sas = annotations.memberAnnotations as? [StopAndSearch] {
            print(sas)
        }
    }
    
    fileprivate func showDetailsForSingleAnnotation(_ annotation: MKAnnotation) {
        switch annotation {
        case let crime as Crime:
            showDetails(for: crime)
        case let stopAndSearch as StopAndSearch:
            print(stopAndSearch)
        default:
            break
        }
    }
    
    private func showDetails(for crimes: [Crime]) {
        
        let crimesViewModel = CrimesViewModel(with: crimes)
        crimesViewModel.presenter = presenter
        detailsViewController.viewModel = crimesViewModel
        showDetails?()
    }
    
    private func showDetails(for crime: Crime) {
        UpdateManager.updateOutcomes(forCrime: crime) { (success) in
            self.detailsViewController.viewModel = CrimeViewModel(with: crime)
            DispatchQueue.main.async {
                self.showDetails?()
            }
        }
    }
    
    private func displayAnnotations(_ annotations: [Annotable]) {
        
        DispatchQueue.main.async {
            
            self.mapView.addAnnotations(annotations)
            self.currentlyShownAnnotations.append(contentsOf: annotations)
            
            if self.isShowingNeighbourhood {
                if let polygon = self.mapView.overlays.first as? MKPolygon {
                    self.removeAnnotationsOutsidePolygon(polygon)
                }
            }
        }
    }
    
    private func resetAnnotations() {
        
        currentlyShownAnnotations = []
        mapView.removeAnnotations(mapView.annotations)
        mapPolygon = nil
    }
    
    private func removeAnnotationsOutsidePolygon(_ polygon: MKPolygon) {
        
        let toRemove = currentlyShownAnnotations.filter { !polygon.contains(point: $0.coordinate)}
        currentlyShownAnnotations = currentlyShownAnnotations.filter { polygon.contains(point: $0.coordinate)}
        mapView.removeAnnotations(toRemove)
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
}


extension MapViewModel: MKMapViewDelegate {
    
    // MARK: - MapView Delegates
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        if !isShowingNeighbourhood {
            retrieveData()
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
            
            return rendererFor(overlay)
        }
        return MKOverlayRenderer()
    }
    
    
    fileprivate func rendererFor(_ overlay: MKPolygon) -> MKOverlayRenderer {
        
        let renderer = MKPolygonRenderer(polygon: overlay)
        renderer.fillColor = UIColor.black.withAlphaComponent(0.2)
        renderer.strokeColor = .blue
        renderer.lineWidth = 1
        
        DispatchQueue.main.async {
            self.mapView.setVisibleMapRect(overlay.boundingMapRect,
                                           edgePadding: UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0),
                                           animated: true)
        }
        return renderer
    }
    
    
    // MARK: - Map Location
    
    private func zoom(into location: CLLocation) {
        
        setMapLocation(location, animated: true)
    }
    
    
    private func setMapLocation(_ location: CLLocation, animated: Bool) {
        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        mapView.setRegion(region, animated: animated)
    }
    
    
    private func positionMapNearUser() {
        
        if let locationDict = UserDefaults.standard.object(forKey: "LAST_LOCATION") as? [String: CLLocationDegrees],
            let location = locationDict.location {
            initialLocation = location
            setMapLocation(location, animated: false)
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
            
            let newPolygon = existingPoligon.merge(with: mapView.visibleRectPolygon)
            if !existingPoligon.contains(newPolygon) {
                
                updateCrimes(for: newPolygon)
            }
            
        } else {
            
            updateCrimes(for: mapView.visibleRectPolygon)
        }
    }
    
    private func updateCrimes(for polygon: MKPolygon) {
        
        networkCallsCounter += 1
        UpdateManager.updateCrimes(within: mapView.visibleMapRect) { [weak self] (error) in
            if error != nil {
                print("Error updating crimes from beckend: \(error.debugDescription)")
            } else {
                self?.fetchSavedCrimes()
                self?.mapPolygon = polygon
            }
            self?.networkCallsCounter -= 1
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
            selecteNeighbourhoodDidChange?(neighbourood.name)
            retrieveData()
        }
    }
}


// MARK: - Search

extension MapViewModel: SearchResultsDelegate {
    
    func searchResultsController(_ sec: SearchResultsController, didSelectLocation description: String) {
        
        findMapItems(with: description)
    }
    
    private func findLocations(with text: String) {
        
        findMapItems(with: text)
    }
    
    private func findMapItems(with text: String) {
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = text
        let search = MKLocalSearch(request: request)
        
        search.start {  [weak self] (response, error) in
            
            if let response = response {
                let responseLocation = CLLocation(latitude: response.boundingRegion.center.latitude,
                                                  longitude: response.boundingRegion.center.longitude)
                self?.location = responseLocation
                self?.zoom(into: responseLocation)
            }
        }
    }
}

// MARK: - Location

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
