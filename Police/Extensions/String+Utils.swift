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
    
    func stripOutHtml() -> String? {
        
        do {
            guard let data = self.data(using: .unicode) else {
                return nil
            }
            let attributed = try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
            return attributed.string
        } catch {
            return nil
        }
    }
    
    var periodDate: Date? {

        let date = self.split(separator: "-").dropLast()
        
            guard date.count == 2,
            let month = date.last,
                month.count == 2,
            let monthNumber = Int(month),
                monthNumber.isValidMonth,
            let year = date.first,
                year.count == 4,
            let yearNumber = Int(year),
                yearNumber.isValidYear
            else { return nil }
        
        return Date.date(fromDay: 1, month: monthNumber, year: yearNumber)
    }
    
    var dateValue: NSDate? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_GB")
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let dateString = self.count > 19 ? String(self[..<self.index(self.startIndex, offsetBy: 19)]) : self
        
        return  dateFormatter.date(from:dateString) as NSDate?
    }
    
    var dateTime: NSDate? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_GB")
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss Z"
        return  dateFormatter.date(from: self) as NSDate?
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

// MARK: - Optional String

extension Optional where Wrapped == String {
    
    var number: NSNumber? {
        
        guard let numberString = self, let double = Double(numberString) else { return nil }
        return NSNumber(value: double)
    }
}

extension Dictionary {
    
    var location: CLLocation? {
        
        if let locationDictionary = self as? [String: CLLocationDegrees],
            let latitude = locationDictionary["latitude"],
            let longitude = locationDictionary["longitude"] {
            return CLLocation(latitude: latitude, longitude: longitude)
        }
        return nil
    }
}

public extension UISearchBar {
    
    func setTextColor(color: UIColor) {
        let svs = subviews.flatMap { $0.subviews }
        guard let tf = (svs.filter { $0 is UITextField }).first as? UITextField else { return }
        tf.textColor = color
    }
    
    func setBackgroundColor(color: UIColor) {
        let svs = subviews.flatMap { $0.subviews }
        guard let tf = (svs.filter { $0 is UITextField }).first as? UITextField else { return }
        tf.backgroundColor = color
    }
}
