//
//  OutcomeCell.swift
//  Police
//
//  Created by Riccardo on 15/04/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import UIKit

class OutcomeCell: UITableViewCell, Loadable {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var item: Outcome? {
        didSet {
            guard let outcome = item else { return }
            configure(with: outcome)
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(with outcome: Outcome) {
        
        if let dateDescription = outcome.date?.dateDescription {
            dateLabel.text = dateDescription
        } else {
            dateLabel.text = nil
        }
        
        let outcomeDescription = outcome.category?.description ?? "No outcome yet"
        descriptionLabel.text = outcomeDescription
    }
    
}
