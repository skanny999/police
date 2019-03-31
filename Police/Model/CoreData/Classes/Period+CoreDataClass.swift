//
//  Period+CoreDataClass.swift
//  Police
//
//  Created by Riccardo on 30/03/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Period)
public class Period: NSManagedObject {
    
    static func createPeriod(fromDate date: NSDate, isSelected: Bool, in context: NSManagedObjectContext) {
        
        let period = Period(entity: self.entity(), insertInto: context)
        period.date = date
        period.isSelected = isSelected
        
    }
    
    var stringDescription: String {
        
        return date!.queryDescription
    }

}
