//
//  String+Utils.swift
//  Police
//
//  Created by Riccardo on 29/01/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import Foundation

extension NSDate {

    var component: (day: Int, month: Int, year: Int, hour: Int) {
        
        let date = self as Date
        let calendar = Calendar.current
        
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let hour = calendar.component(.hour, from: date)
        let year = calendar.component(.year, from: date)
        
        return (day: day, month: month, year: year , hour:hour)
    }
}



