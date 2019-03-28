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
        
        let prima = CLLocationCoordinate2DMake(51.6, 0.0)
        let seconda = CLLocationCoordinate2DMake(51.4, 0.0)
        let terza = CLLocationCoordinate2DMake(51.5, 0.3)
        var coordinate = [prima, seconda, terza]
        let secondoPoligono = MKPolygon(coordinates: &coordinate, count: 3)
        let jointPolygon = polygon.fromUnion(with:secondoPoligono)
        
        mapView.addOverlay(jointPolygon!)
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


