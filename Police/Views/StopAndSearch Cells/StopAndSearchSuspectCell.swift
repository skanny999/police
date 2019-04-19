//
//  StopAndSearchSuspectCell.swift
//  Police
//
//  Created by Riccardo on 19/04/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import UIKit

class StopAndSearchSuspectCell: UITableViewCell, Loadable {
    
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var ethnicityLabel: UILabel!
    
    var item: StopAndSearchViewModelSuspect? {
        
        didSet {
            genderLabel.text = item?.gender
            ageLabel.text = item?.age
            ethnicityLabel.text = item?.ethnicity
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
