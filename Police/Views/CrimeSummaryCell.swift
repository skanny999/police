//
//  CrimeSummaryCell.swift
//  Police
//
//  Created by Riccardo on 14/04/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import UIKit

class CrimeSummaryCell: UITableViewCell {

    @IBOutlet weak var crimeDescription: UILabel!
    @IBOutlet weak var crimeImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with crime: Crime) {
        
        crimeDescription.text = crime.category?.description
        crimeImage.image = crime.category?.image
    }

    
    class var identifier: String {
        
        return String(describing: self)
    }
    
    class var nib: UINib {
        
        return UINib(nibName: identifier, bundle: nil)
    }
    
}
