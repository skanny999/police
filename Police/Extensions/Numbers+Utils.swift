//
//  Numbers+Utils.swift
//  Police
//
//  Created by Riccardo on 31/01/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import Foundation

extension Double {
    
    var short: Double {

        return Double((self * 1000000).rounded() / 1000000)
    }
}
