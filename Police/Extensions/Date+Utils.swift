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
        return (day: date.component.day, month: date.component.month, year: date.component.year , hour:date.component.hour)
    }
}



extension Date {
    
    var component: (day: Int, month: Int, year: Int, hour: Int) {
        
        let calendar = Calendar.current
        let day = calendar.component(.day, from: self)
        let month = calendar.component(.month, from: self)
        let hour = calendar.component(.hour, from: self)
        let year = calendar.component(.year, from: self)
        
        return (day: day, month: month, year: year , hour:hour)
    }
    
    static func date(fromDay day: Int, month: Int, year: Int) -> Date {
        
        var components = DateComponents()
        components.day = day
        components.month = month
        components.year = year
        return Calendar.current.date(from: components)!
    }
    
    func previousAvailableDates() -> [Date] {
        
        var previousAvailableDates = [Const.firstPeriod]
        
        while previousAvailableDates.last ?? self < self {
            
            let newDate = Calendar.current.date(byAdding: .month, value: 1, to: previousAvailableDates.last!)
            previousAvailableDates.append(newDate!)
        }
        
        return previousAvailableDates
    }
}



