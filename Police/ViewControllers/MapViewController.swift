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
    func mapViewController(_ mapViewController: MapViewController, didTapMapWith sender: UITapGestureRecognizer)
}

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var neighbourhoodLabel: UILabel!
    @IBOutlet weak var neighbourhoodDetailsButton: UIButton!
    
    var searchController: UISearchController?

    var viewModel: MapViewModel!
    var delegate: MapViewControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
        configureSearchResultsController()
        configureGestureRecogniser()
    }
    
    private func configureViewModel() {
        
        viewModel = MapViewModel(with: mapView)
        self.delegate = viewModel
        viewModel.selecteNeighbourhoodDidChange = { (selectedNeighbourhood) in
            DispatchQueue.main.async {
                self.updateViewWith(selectedNeighbourhood)
            }
        }
    }
    
    private func configureSearchResultsController() {

        navigationItem.searchController = configuredSearchController()
    }
    
    private func updateViewWith(_ neighbourhood: String?) {
        
        if let neighbourhood = neighbourhood {
            neighbourhoodLabel.text = neighbourhood
            hideSearchController()
        } else {
            showSearchController()
        }
    }
    
    private func showSearchController() {
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.navigationItem.searchController = self?.configuredSearchController()
        }) { (completed) in
            self.neighbourhoodLabel.text = nil
        }
    }
    
    private func hideSearchController() {
        
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.navigationItem.searchController = nil
        }
    }
    
    private var searchControllerIsShowing: Bool {
        
        return navigationItem.searchController != nil
    }
    
    func configuredSearchController() -> UISearchController {
        
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
        definesPresentationContext = true
        return searchController!
    }
    
    private func configureGestureRecogniser() {
        
        let gestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(mapTapped(sender:)))
        mapView.addGestureRecognizer(gestureRecogniser)
    }
    
    @objc private func mapTapped(sender: UITapGestureRecognizer) {
        
        delegate?.mapViewController(self, didTapMapWith: sender)
    }
    
    @IBAction func crimeButtonTapped(_ sender: Any) {
        
        delegate?.mapViewController(self, didTapButtonForMode: .crime)
    }
    
    @IBAction func policeButtonTapped(_ sender: Any) {
        
        delegate?.mapViewController(self, didTapButtonForMode: .police)
    }
    
}




