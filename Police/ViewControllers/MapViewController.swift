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
    
    var crimeButton: UIBarButtonItem!
    var policeButton: UIBarButtonItem!
    var activityButton: UIBarButtonItem!
    let activityIndicator = UIActivityIndicatorView()
    let crimeImage = UIImage(named: "crime")!
    let selectedCrimeImage = UIImage(named: "crime-selected")!
    let policeImage = UIImage(named: "police")!
    let selectedPoliceImage = UIImage(named: "police-selected")!
    
    
    @IBOutlet weak var neighbourhoodDetailsButton: UIButton!
    @IBOutlet weak var neighbourhoodLabel: UILabel!

    
    @IBOutlet weak var neighbourhoodConstraint: NSLayoutConstraint!
    var searchController: UISearchController?

    var viewModel: MapViewModel!
    var delegate: MapViewControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
        configureSearchResultsController()
        configureGestureRecogniser()
        configureBarButtonItems()
    }
    
    private func configureBarButtonItems() {
        crimeButton = UIBarButtonItem(image: crimeImage, style: .plain, target: self, action: #selector(crimeButtonTapped))
        policeButton = UIBarButtonItem(image: policeImage, style: .plain, target: self, action: #selector(policeButtonTapped))
        activityButton = UIBarButtonItem.init(customView: activityIndicator)
        navigationItem.setLeftBarButton(crimeButton, animated: false)
        navigationItem.setRightBarButton(policeButton, animated: false)
    }
    
    private func configureViewModel() {
        
        viewModel = MapViewModel(with: mapView)
        self.delegate = viewModel
        configureViewUpdater()
    }
    
    private func configureViewUpdater() {
        
        viewModel.selecteNeighbourhoodDidChange = { (selectedNeighbourhood) in
            DispatchQueue.main.async {
                self.updateViewWith(selectedNeighbourhood)
            }
        }
        
        viewModel.dataIsLoading = { (isLoading) in
            DispatchQueue.main.async {
                self.updateActivityIndicator(status: isLoading)
            }
        }
    }
    
    private func updateActivityIndicator(status dataIsLoading: Bool) {
        
        let selectedMode = viewModel.mapMode
        if selectedMode == .none { return }
        let barButton: UIBarButtonItem = selectedMode == .crime ? crimeButton : policeButton
        
        func setNavigationItem(toButton button: UIBarButtonItem) {
            selectedMode == .crime ? navigationItem.setLeftBarButton(button, animated: true) : navigationItem.setRightBarButton(button, animated: true)
        }
        
        switch (dataIsLoading, activityIndicator.isAnimating) {
        case (true, true):
            return
        case (true, false):
            setNavigationItem(toButton: activityButton)
            activityIndicator.startAnimating()
        case (false, true):
            setNavigationItem(toButton: barButton)
            activityIndicator.stopAnimating()
        case (false, false):
            return
        }
    }
    
    
    
    
    private func configureSearchResultsController() {

        navigationItem.searchController = configuredSearchController()
    }
    
    private func updateViewWith(_ neighbourhood: String?) {
        
        if let neighbourhood = neighbourhood?.capitalized.stripOutHtml() {
            neighbourhoodLabel.text = neighbourhood
            showNeighbourhoodSelector()
        } else {
            hideNeighbourhoodSelector()
        }
    }
    
    private func hideNeighbourhoodSelector() {
        neighbourhoodConstraint.constant = -44
        self.neighbourhoodLabel.text = nil
    }
    
    private func showNeighbourhoodSelector() {
        neighbourhoodConstraint.constant = 0

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
        searchController?.searchBar.subviews.forEach({ view in
            view.subviews.forEach({ view in
                if let view = view as? UITextField, let backgroud = view.subviews.first {
                    backgroud.backgroundColor = .white
                    backgroud.layer.cornerRadius = 10
                    backgroud.clipsToBounds = true
                }
            })
        })


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
    
    @objc private func crimeButtonTapped() {
        if viewModel.mapMode != .crime {
            delegate?.mapViewController(self, didTapButtonForMode: .crime)
            crimeButton.image = selectedCrimeImage
            policeButton.image = policeImage
        }
    }
    
    @objc private func policeButtonTapped() {
        if viewModel.mapMode != .police {
            delegate?.mapViewController(self, didTapButtonForMode: .police)
            policeButton.image = selectedPoliceImage
            crimeButton.image = crimeImage
        }
    }
    
    @IBAction func neighbourhoodButtonPressed(_ sender: Any) {
        
        
    }
}




