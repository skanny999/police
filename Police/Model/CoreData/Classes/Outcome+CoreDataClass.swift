//
//  Outcome+CoreDataClass.swift
//  Police
//
//  Created by Riccardo on 23/01/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//
//

import Foundation
import CoreData
import SwiftyJSON

@objc(Outcome)
public class Outcome: NSManagedObject {
    
    var category: OutcomeCategory? {
        guard let code = self.categoryCode else { return nil }
        return OutcomeCategory(rawValue: code)
    }
    
    struct Key {
        static let category = "category"
        static let categoryCode = "code"
        static let date = "date"
        static let personId = "person_id"
    }
    
    class func newOutcome(from json: JSON, in context: NSManagedObjectContext) -> Outcome {
        
        let outcome = Outcome(entity: self.entity(), insertInto: context)
        outcome.categoryCode = json[Key.category][Key.categoryCode].string
        outcome.date = json[Key.date].string
        outcome.personId = json[Key.personId].string
        return outcome
    }
    

}
