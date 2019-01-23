//
//  Location+CoreDataProperties.swift
//  Police
//
//  Created by Riccardo on 23/01/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var latitude: NSNumber
    @NSManaged public var longitude: NSNumber
    @NSManaged public var crime: Crime?
    @NSManaged public var event: Event?
    @NSManaged public var neighbourhood: Neighbourhood?
    @NSManaged public var place: Place?
    @NSManaged public var stopAndSearch: StopAndSearch?

}
