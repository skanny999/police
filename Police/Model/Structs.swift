//
//  DateModel.swift
//  Police
//
//  Created by Riccardo on 27/01/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import Foundation

struct Period {
    let month: String
    let year: String
    
    var dateString: String {
        return "\(year)-\(month)"
    }
}

