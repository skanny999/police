//
//  Outcome+CoreDataProperties.swift
//  Police
//
//  Created by Riccardo on 23/01/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//
//

import Foundation
import CoreData


extension Outcome {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Outcome> {
        return NSFetchRequest<Outcome>(entityName: "Outcome")
    }

    @NSManaged public var categoryCode: String?
    @NSManaged public var date: NSDate?
    @NSManaged public var personId: String?
    @NSManaged public var crime: Crime?

}
