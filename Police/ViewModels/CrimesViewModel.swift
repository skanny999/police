//
//  CrimesViewModel.swift
//  Police
//
//  Created by Riccardo on 13/04/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import Foundation
import UIKit

enum CrimeViewModelItemType {
    
    case summary
    case period
    case details
    case outcome
}

protocol CrimeViewModelItem {
    
    var type: CrimeViewModelItemType { get }
    var rowCount: Int { get }
}


class CrimesViewModel: NSObject, Displayable {

    var crimesList: CrimeViewModelItem
    
    init(with crimes: [Crime]) {
        
        crimesList = CrimeViewModelSummary(with: crimes)
        super.init()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return crimesList.rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let list = crimesList as? CrimeViewModelSummary,
            let cell = tableView.dequeueReusableCell(withIdentifier: CrimeSummaryCell.identifier, for: indexPath) as? CrimeSummaryCell {
            
            let crime = list.crimes[indexPath.row]
            cell.configure(with: crime)
            return cell
        }
        
       return UITableViewCell()
    }
    
}




class CrimeViewModelSummary: CrimeViewModelItem {
    
    let crimes: [Crime]
    
    init(with crimes: [Crime]) {
        self.crimes = crimes
    }
    
    var type: CrimeViewModelItemType {
        return .summary
    }
    
    var rowCount: Int {
        return crimes.count
    }
 
}
