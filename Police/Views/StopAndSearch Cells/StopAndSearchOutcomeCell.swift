//
//  StopAndSearchOutcomeCell.swift
//  Police
//
//  Created by Riccardo on 19/04/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import UIKit

class StopAndSearchOutcomeCell: UITableViewCell, Loadable {
    
    @IBOutlet weak var outcomeLabel: UILabel!
    
    var item: StopAndSearchViewModelOutcome? {
        didSet {
            outcomeLabel.text = item?.outcome
            outcomeLabel.textColor = item?.colour != Colour.white ? item?.colour : Colour.blue
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        isUserInteractionEnabled = false
    }
    
}
