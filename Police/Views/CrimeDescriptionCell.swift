//
//  CrimeSummaryCell.swift
//  Police
//
//  Created by Riccardo on 14/04/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import UIKit

class CrimeDescriptionCell: UITableViewCell, Loadable {

    @IBOutlet weak var crimeDescription: UILabel!
    @IBOutlet weak var crimeImage: UIImageView!
    
    var item: CrimeViewModelItem? {
        didSet {
            guard let item = item as? CrimeViewModelDescription else { return }
            configure(with: item.crime)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with crime: Crime) {
        
        crimeDescription.text = crime.category?.description
        crimeImage.image = crime.category?.image
    }

}
