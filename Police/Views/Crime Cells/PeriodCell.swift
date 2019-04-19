//
//  PeriodCell.swift
//  Police
//
//  Created by Riccardo on 15/04/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import UIKit

class PeriodCell: UITableViewCell, Loadable {

    @IBOutlet weak var locationLabel: UILabel!
    
    var item: CrimeViewModelItem? {
        didSet {
            guard let periodItem = item as? CrimeViewModelPeriod else { return }
            locationLabel.text = periodItem.period
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    

    
}
