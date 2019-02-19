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
    
    var dateValue: NSDate? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_GB")
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
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
    

    
}

