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

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var searchController: UISearchController?

    
    let viewModel = MapViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = viewModel
        configureSearchResultsController()
    }

    
    private func configureSearchResultsController() {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let searchResultsController = storyBoard.instantiateViewController(withIdentifier: "SearchResultsController") as? SearchResultsController
        searchResultsController?.mapView = mapView
        searchResultsController?.delegate = viewModel
        searchController = UISearchController(searchResultsController: searchResultsController)
        searchResultsController?.searchBar = searchController?.searchBar
        searchController?.searchResultsUpdater = searchResultsController
        searchController?.searchBar.sizeToFit()
        searchController?.searchBar.placeholder = "Find a location"
        searchController?.hidesNavigationBarDuringPresentation = false
        searchController?.dimsBackgroundDuringPresentation = true
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
}


