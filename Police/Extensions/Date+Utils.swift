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
    
    var queryDescription: String {
    
        let month = self.component.month
        
        let monthString = 1...9 ~= month ? "0\(month)" : "\(month)"
        let yearString = "\(self.component.year)"
        
        return "\(yearString)-\(monthString)"
        
        
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
        return Calendar.current.date(from: components)!.offsettingDaylightSaving()
    }
    
    func previousAvailableDates() -> [Date] {
        
        var previousAvailableDates = [Const.firstPeriod]
        
        while previousAvailableDates.last ?? self < self {
            
            let date = Calendar.current.date(byAdding: .month, value: 1, to: previousAvailableDates.last!)!.offsettingDaylightSaving()
            let newDate = Date.date(fromDay: date.component.day, month: date.component.month, year: date.component.year)
            previousAvailableDates.append(newDate)
        }
        
        return previousAvailableDates
    }
    
    
    private func offsettingDaylightSaving() -> Date {
        
        return self.addingTimeInterval(TimeZone.current.daylightSavingTimeOffset(for: self))
    }
}

extension Optional where Wrapped == NSDate {
    
    var longDescription: String? {
        
        guard let date = self as Date? else { return nil }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short

        return formatter.string(from: date)
    }
}



