//
//  ViewController.swift
//  Police
//
//  Created by Riccardo on 17/01/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved
//

import UIKit
import Foundation
import MapKit

protocol MapViewControllerDelegate {
    
    func mapViewController(_ mapViewController: MapViewController, didTapButtonForMode mode: Mode)
}

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var searchController: UISearchController?

    var viewModel: MapViewModel!
    var delegate: MapViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = MapViewModel(with: mapView)
        configureSearchResultsController()
        self.delegate = viewModel
        
        let first = CLLocationCoordinate2DMake(51.5, 0.0)
        let second = CLLocationCoordinate2DMake(51.3, 0.0)
        let third = CLLocationCoordinate2DMake(51.4, 0.2)
        var coordinates = [first, second, third]
        let polygon = MKPolygon(coordinates: &coordinates, count: 3)
//        mapView.addOverlay(polygon)
        
        if let data = coordinatesData(from: polygon) {

            if let polygon = mapPolygon(form: data) {

                for point in UnsafeBufferPointer(start: polygon.points(), count: polygon.pointCount) {

                    print("latitude: \(point.y), longitude: \(point.x)")
                }

                mapView.addOverlay(polygon)
            }
        }
        
        
    }
    
    private func configureSearchResultsController() {

        let searchResultsController = Storyboard.searchResultsController()
        searchController = UISearchController(searchResultsController: searchResultsController)
        searchResultsController.mapView = mapView
        searchResultsController.delegate = viewModel
        searchResultsController.searchBar = searchController?.searchBar
        searchController?.searchResultsUpdater = searchResultsController
        searchController?.searchBar.sizeToFit()
        searchController?.searchBar.placeholder = "Find a location"
        searchController?.hidesNavigationBarDuringPresentation = false
        searchController?.dimsBackgroundDuringPresentation = true
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    @IBAction func crimeButtonTapped(_ sender: Any) {
        
        delegate?.mapViewController(self, didTapButtonForMode: .crime)
    }
    
    @IBAction func policeButtonTapped(_ sender: Any) {
        
        delegate?.mapViewController(self, didTapButtonForMode: .police)
    }
    
}

 // MARK: - Testing polygon

extension MapViewController {
    
    func coordinatesData(from polygon: MKPolygon) -> NSData? {
        
        let coordsPointer = UnsafeMutablePointer<CLLocationCoordinate2D>.allocate(capacity: polygon.pointCount)
        polygon.getCoordinates(coordsPointer, range: NSMakeRange(0, polygon.pointCount))
        
        var points: [PointCoordinates] = []
        
        for i in 0..<polygon.pointCount {
            let latitude = coordsPointer[i].latitude
            let longitude = coordsPointer[i].longitude
            points.append(PointCoordinates(latitude: latitude, longitude: longitude))
        }

        do {
            return try NSKeyedArchiver.archivedData(withRootObject: points as Array, requiringSecureCoding: false) as NSData
        } catch  {
            print(error)
            return nil
        }
    }
    
    func mapPolygon(form data: NSData) -> MKPolygon? {
        
        guard let coordinates = data as Data? else { return nil }
        
        do {
            let points = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self, PointCoordinates.self] , from: coordinates)
            
            return polygon(from: points as! [PointCoordinates])
            
        } catch  {
            print(error)
            return nil
        }
    }
    
    func polygon(from points: [PointCoordinates]) -> MKPolygon {
        
        var locations: [CLLocationCoordinate2D] = []
        for point in points {
            let pointCoordinates = CLLocationCoordinate2DMake(point.latitude, point.longitude)
            locations.append(pointCoordinates)
        }
        
        points.forEach { print("latitude: \($0.latitude), longitude: \($0.longitude)") }
        
        return MKPolygon(coordinates: &locations, count: locations.count)
    }
    
    
    
    
}


