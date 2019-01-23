//
//  Force+CoreDataProperties.swift
//  Police
//
//  Created by Riccardo on 23/01/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//
//

import Foundation
import CoreData


extension Force {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Force> {
        return NSFetchRequest<Force>(entityName: "Force")
    }

    @NSManaged public var identifier: String?
    @NSManaged public var longDescription: String?
    @NSManaged public var name: String?
    @NSManaged public var contact: Contact?
    @NSManaged public var officers: Set?

}

// MARK: Generated accessors for officers
extension Force {

    @objc(addOfficersObject:)
    @NSManaged public func addToOfficers(_ value: Officer)

    @objc(removeOfficersObject:)
    @NSManaged public func removeFromOfficers(_ value: Officer)

    @objc(addOfficers:)
    @NSManaged public func addToOfficers(_ values: Set<Officer>)

    @objc(removeOfficers:)
    @NSManaged public func removeFromOfficers(_ values: Set<Officer>)

}
