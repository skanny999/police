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
    
    init(with crimes: [Crime]) {
        super.init()
        items.append(CrimeViewModelSummary(crimes: crimes))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.first!.rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let crimeList = items.first!
        if let list = crimeList as? CrimeViewModelSummary,
            let cell = tableView.dequeueReusableCell(withIdentifier: CrimeDescriptionCell.identifier, for: indexPath) as? CrimeDescriptionCell {
            let crimeItem = list.crimes[indexPath.row]
            cell.configure(with: crimeItem)
            return cell
        }
        
       return UITableViewCell()
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
        return "Crimes"
    }
 
}
