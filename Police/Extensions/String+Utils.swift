//
//  String+Utils.swift
//  Police
//
//  Created by Riccardo on 29/01/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import Foundation

extension String {
    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
    
    var isValidMonth: Bool {
        
        guard let integer = Int(self) else { return false }
        return 1 ... 12 ~= integer
    }
    
    var isValidYear: Bool {
        
        guard let integer = Int(self) else { return false }
        let year = Calendar.current.component(.year, from:Date())
        return 2014 ... year ~= integer
    }
}
