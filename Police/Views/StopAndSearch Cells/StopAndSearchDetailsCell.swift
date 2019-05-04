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
            imageForDetails()
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
        isUserInteractionEnabled = isSelectable ?? false
        descriptionLabel.contentMode = .scaleToFill
    }
    
    private func imageForDetails() {
        
        detailImageView.layer.cornerRadius = 30
        detailImageView.layer.masksToBounds = true
        detailImageView.image = item?.image
        detailImageView.backgroundColor = item?.colour
        
        if item?.colour == Colour.white {

            detailImageView.tintColor = Colour.blue
            detailImageView.layer.borderWidth = 1
            detailImageView.layer.borderColor = Colour.blue.cgColor
            
        } else {
            detailImageView.tintColor = Colour.white
        }
    }

    
}
