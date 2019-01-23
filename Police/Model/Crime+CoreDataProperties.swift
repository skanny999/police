//
//  Crime+CoreDataProperties.swift
//  Police
//
//  Created by Riccardo on 23/01/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//
//

import Foundation
import CoreData


extension Crime {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Crime> {
        return NSFetchRequest<Crime>(entityName: "Crime")
    }

    @NSManaged public var categoryCode: String?
    @NSManaged public var extraContent: String?
    @NSManaged public var identifier: NSNumber
    @NSManaged public var locationId: NSNumber
    @NSManaged public var locationSubtypeCode: String?
    @NSManaged public var locationTypeCode: String?
    @NSManaged public var month: String?
    @NSManaged public var persistentId: String?
    @NSManaged public var streetName: String?
    @NSManaged public var year: String?
    @NSManaged public var location: Location?
    @NSManaged public var outcomes: Set?

}

// MARK: Generated accessors for outcomes
extension Crime {

    @objc(addOutcomesObject:)
    @NSManaged public func addToOutcomes(_ value: Outcome)

    @objc(removeOutcomesObject:)
    @NSManaged public func removeFromOutcomes(_ value: Outcome)

    @objc(addOutcomes:)
    @NSManaged public func addToOutcomes(_ values: Set<Outcome>)

    @objc(removeOutcomes:)
    @NSManaged public func removeFromOutcomes(_ values: Set<Outcome>)

}
