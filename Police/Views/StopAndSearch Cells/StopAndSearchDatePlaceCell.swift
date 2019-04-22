//
//  StopAndSearchDatePlaceCell.swift
//  Police
//
//  Created by Riccardo on 19/04/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import UIKit

class StopAndSearchDatePlaceCell: UITableViewCell, Loadable {
    
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    
    var item: StopAndSearchViewModelDatePlace? {
        didSet {
            dateTimeLabel.text = item?.date
            placeLabel.text = item?.place
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        isUserInteractionEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
