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
    var detailsViewController: SelectionDetailsViewController!

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
        viewModel.setDetailsController(detailsViewController)
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
        
        switch (dataIsLoading, activityIndicator.isAnimating) {
        case (true, true):
            return
        case (true, false):
            setButton(barButton, isSpinner: true, forMode: selectedMode)
            activityIndicator.startAnimating()
        case (false, true):
            setButton(barButton, isSpinner: false, forMode: selectedMode)
            activityIndicator.stopAnimating()
        case (false, false):
            return
        }
    }
    
    
    
    private func setButton(_ button: UIBarButtonItem, isSpinner: Bool, forMode mode: Mode) {
        
        let newButton = isSpinner ? activityButton : button
        switch mode {
        case .crime:
            navigationItem.setLeftBarButton(newButton, animated: true)
        case .police:
            navigationItem.setRightBarButton(newButton, animated: true)
        case .none:
            return
        }
        
    }
    
    private func resetNavigationItemButton(_ button: UIBarButtonItem, forMode mode: Mode) {
        
        switch mode {
        case .crime:
            navigationItem.setRightBarButton(button, animated: true)
        case .police:
            navigationItem.setLeftBarButton(button, animated: true)
        case .none:
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

        let newMode: Mode = (viewModel.mapMode == .crime) ? .none : .crime
        resetNavigationItemButton(policeButton, forMode: newMode)
        
        switch viewModel.mapMode {
        case .crime:
            crimeButton.image = crimeImage
        case .police:
            policeButton.image = policeImage
            crimeButton.image = selectedCrimeImage
        case .none:
            crimeButton.image = selectedCrimeImage
        }
        
        delegate?.mapViewController(self, didTapButtonForMode: newMode)
    }
    
    @objc private func policeButtonTapped() {
        
        let newMode: Mode = viewModel.mapMode == .police ? .none : .police
        resetNavigationItemButton(crimeButton, forMode: newMode)
        
        switch viewModel.mapMode {
        case .crime:
            policeButton.image = selectedPoliceImage
            crimeButton.image = crimeImage
        case .police:
            policeButton.image = policeImage
        case .none:
            policeButton.image = selectedPoliceImage
        }
        
        delegate?.mapViewController(self, didTapButtonForMode: newMode)
    }
    
    @IBAction func neighbourhoodButtonPressed(_ sender: Any) {
        
        // did select neighbourhood
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "DETAILS_SEGUE" {
            if let navigationController = segue.destination as? UINavigationController,
                let detailsController = navigationController.viewControllers.first as? SelectionDetailsViewController {
                detailsViewController = detailsController
            } else {
                fatalError("Couldn't set details controller")
            }
        }
    }
}




