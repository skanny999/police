//
//  Event+CoreDataProperties.swift
//  Police
//
//  Created by Riccardo on 23/01/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//
//

import Foundation
import CoreData


extension Event {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Event> {
        return NSFetchRequest<Event>(entityName: "Event")
    }
    //delete and parse
    @NSManaged public var address: String?
    @NSManaged public var endDate: NSDate?
    @NSManaged public var longDescription: String?
    @NSManaged public var startDate: NSDate?
    @NSManaged public var title: String?
    @NSManaged public var typeCode: String?
    @NSManaged public var contact: Contact?
    @NSManaged public var location: Location?
    @NSManaged public var neighbourhood: Neighbourhood?

}
