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
    
    var monthDescription: String? {
        
        guard self.isValidMonth else { return nil }
        
        switch self {
        case "01":
            return "January"
        case "02":
            return "February"
        case "03":
            return "March"
        case "04":
            return "April"
        case "05":
            return "May"
        case "06":
            return "June"
        case "07":
            return "July"
        case "08":
            return "August"
        case "09":
            return "September"
        case "10":
            return "October"
        case "11":
            return "November"
        case "12":
            return "December"
        default:
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
    
    var dateDescription: String? {
        
        let date = self.split(separator: "-")
        
        guard date.count == 2,
            let month = date.last,
            month.count == 2,
            let monthNumber = Int(month),
            monthNumber.isValidMonth,
            let monthDescription = String(month).monthDescription,
            let year = date.first,
            year.count == 4,
            let yearNumber = Int(year),
            yearNumber.isValidYear
            else { return nil }
        
        return "\(monthDescription) \(year)"
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

extension UIView {
    func fadeIn(_ duration: TimeInterval = 0.3, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: completion)  }
    
    func fadeOut(_ duration: TimeInterval = 0.3, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.alpha = 0.0
        }, completion: completion)
    }
}


extension UILabel {
    
    func updateWithText(_ text: String) {
        
        self.fadeOut()
        self.text = text
        self.fadeIn()
    }
}
