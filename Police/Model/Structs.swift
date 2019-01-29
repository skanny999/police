//
//  DateModel.swift
//  Police
//
//  Created by Riccardo on 27/01/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import Foundation

struct Period {
    
    init?(fromMonth monthDate: String?) {
        
        guard let monthDate = monthDate else { return nil }
        
        let date = monthDate.split(separator: "-")

        guard
            date.count == 2,
            let month = date.last, month.count == 2, String(month).isAlphanumeric, String(month).isValidMonth,
            let year = date.first, year.count == 4, String(year).isAlphanumeric, String(year).isValidYear
            else { return nil }
        
        self.month = String(month)
        self.year = String(year)
    }
    
    let month: String
    let year: String
    
    var dateString: String {
        return "\(year)-\(month)"
    }
}

