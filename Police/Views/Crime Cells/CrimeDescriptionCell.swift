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
    
    var item: Crime? {
        didSet {
            guard let crime = item else { return }
            configure(with: crime)
        }
    }
    
    var isSelectable: Bool? {
        didSet {
            self.isUserInteractionEnabled = isSelectable ?? false
            self.accessoryType = isSelectable ?? false ? .disclosureIndicator : .none
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        crimeImage.layer.cornerRadius = 30
        crimeImage.layer.masksToBounds = true
        
    }
    
    func configure(with crime: Crime) {
        
        crimeDescription.text = crime.category?.description
        crimeImage.backgroundColor = crime.category?.colour
        crimeImage.image = crime.category?.image
        crimeImage.tintColor = Colour.white
    }
}


class CrimeSummaryCell: CrimeDescriptionCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.accessoryType = .disclosureIndicator
        self.isUserInteractionEnabled = true
    }
}
