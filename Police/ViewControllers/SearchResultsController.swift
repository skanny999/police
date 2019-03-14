//
//  SearchResultsController.swift
//  Police
//
//  Created by Riccardo on 13/03/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import UIKit
import MapKit

class SearchResultsController: UITableViewController {
    
    var searchCompleter = MKLocalSearchCompleter()
    var matchingItems: [MKLocalSearchCompletion] = []
    var mapView: MKMapView?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCompleter()

    }
    
    private func configureCompleter() {
        
        guard let mapView = mapView else { fatalError("mapview is nil") }
        searchCompleter.region = mapView.region
        searchCompleter.delegate = self
    }
 
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RESULT_CELL", for: indexPath)
        let result = matchingItems[indexPath.row] as MKLocalSearchCompletion
        cell.textLabel?.text = result.title
        return cell
    }
}

extension SearchResultsController: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        
        matchingItems = completer.results
        tableView.reloadData()
        
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print(error)
    }
    
}


extension SearchResultsController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            searchCompleter.queryFragment = searchText
        }
    }  
}
