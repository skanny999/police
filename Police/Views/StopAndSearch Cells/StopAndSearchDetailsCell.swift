//
//  SaSDetailsCell.swift
//  Police
//
//  Created by Riccardo on 19/04/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import UIKit

class StopAndSearchDetailsCell: UITableViewCell, Loadable {

    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var legislationLabel: UILabel!
    
    var item: StopAndSearchViewModelDescription? {
        didSet {
            detailImageView.image = item?.image
            descriptionLabel.text = item?.description
            legislationLabel.text = item?.legislation
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
        // Initialization code
    }

    
}
