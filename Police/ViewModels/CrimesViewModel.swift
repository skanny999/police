//
//  CrimesViewModel.swift
//  Police
//
//  Created by Riccardo on 13/04/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import Foundation
import UIKit


class CrimesViewModel: NSObject, Displayable {

    var items = [CrimeViewModelItem]()
    
    var presenter: UINavigationController!
    
    init(with crimes: [Crime]) {
        super.init()
        items.append(CrimeViewModelSummary(crimes: crimes))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.first!.rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let item = items.first as? CrimeViewModelSummary,
            let cell = tableView.dequeueReusableCell(withIdentifier: CrimeDescriptionCell.identifier, for: indexPath) as? CrimeDescriptionCell {
            let crime = item.crimes[indexPath.row]
            cell.item = crime
            cell.isSelectable = true
            return cell
        }
       return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = items.first as? CrimeViewModelSummary {
            let crime = item.crimes[indexPath.row]
            UpdateManager.updateOutcomes(forCrime: crime) { (success) in
                DispatchQueue.main.async {
                    self.pushDetailsController(for: crime)
                }
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func pushDetailsController(for crime: Crime) {
        
        let detailController = Storyboard.selectionDetailsController()
        detailController.viewModel = CrimeViewModel(with: crime)
        presenter.pushViewController(detailController, animated: true)
    }
}


// MARK: - CellViewModel

struct CrimeViewModelSummary: CrimeViewModelItem {
    
    let crimes: [Crime]
    
    var type: CrimeViewModelItemType {
        return .summary
    }
    
    var rowCount: Int {
        return crimes.count
    }
    
    var sectionTitle: String {
        return ""
    }
}
