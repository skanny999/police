//
//  StopAndSearchesViewModel.swift
//  Police
//
//  Created by Riccardo on 19/04/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import Foundation

class StopAndSearchesViewModel: NSObject, Displayable {
    
    var items = [StopAndSearchViewModelItem]()
    var presenter: UINavigationController!
    
    init(with stopAndSearches: [StopAndSearch]) {
        super.init()
        
        items.append(StopAndSearchSummaryViewModel(stopAndSearches: stopAndSearches))
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.first?.rowCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let item = items.first as? StopAndSearchSummaryViewModel,
        let detailViewModel = viewModelDescription(for: item.stopAndSearches[indexPath.row]),
        let cell = tableView.dequeueReusableCell(withIdentifier: StopAndSearchDetailsCell.identifier, for: indexPath) as? StopAndSearchDetailsCell {
            
            cell.item = detailViewModel
            cell.isSelectable = true
            return cell
        }
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = items.first as? StopAndSearchSummaryViewModel {
            let search = item.stopAndSearches[indexPath.row]
            DispatchQueue.main.async {
                self.pushDetailsController(for: search)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Helper
    
    private func viewModelDescription(for search: StopAndSearch) -> StopAndSearchViewModelDescription? {
        
        guard   let objectOfSearch = search.objectOfSearch,
                let legislation = search.legislation else { return nil }
        
        return StopAndSearchViewModelDescription(description: objectOfSearch,
                                                 legislation: legislation,
                                                 image: search.image,
                                                 colour: search.colour)
    }
    
    private func pushDetailsController(for search: StopAndSearch) {
        
        let detailController = Storyboard.selectionDetailsController()
        detailController.viewModel = StopAndSearchViewModel(with: search)
        presenter.pushViewController(detailController, animated: true)
    }
}

struct StopAndSearchSummaryViewModel: StopAndSearchViewModelItem {
    
    var stopAndSearches: [StopAndSearch]
    
    var type: StopAndSearchItemType {
        return .summary
    }
    
    var sectionTitle: String {
        return ""
    }
    
    var rowCount: Int {
        return stopAndSearches.count
    }
}
