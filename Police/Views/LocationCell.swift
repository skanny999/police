//
//  LocationCell.swift
//  Police
//
//  Created by Riccardo on 15/04/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import UIKit

class LocationCell: UITableViewCell, Loadable {

    @IBOutlet weak var streetLabel: UILabel!
    
    var item: CrimeViewModelItem? {
        didSet {
            if let locationItem = item as? CrimeViewModelLocation {
                streetLabel.text = locationItem.location
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
