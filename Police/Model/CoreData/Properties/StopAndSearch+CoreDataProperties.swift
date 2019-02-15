//
//  StopAndSearch+CoreDataProperties.swift
//  Police
//
//  Created by Riccardo on 23/01/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//
//

import Foundation
import CoreData


extension StopAndSearch {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StopAndSearch> {
        return NSFetchRequest<StopAndSearch>(entityName: "StopAndSearch")
    }
    
    //identifier is datetime
    @NSManaged public var ageRange: String?
    @NSManaged public var dateTime: NSDate?
    @NSManaged public var genderCode: String?
    @NSManaged public var legislation: String?
    @NSManaged public var locationId: NSNumber
    @NSManaged public var objectOfSearch: String?
    @NSManaged public var officerEthnicity: String?
    @NSManaged public var operationName: String?
    @NSManaged public var outCome: String?
    @NSManaged public var outcomeIsLinkedToSearch: NSNumber
    @NSManaged public var outcomeObject: String?
    @NSManaged public var personIsInvolved: NSNumber
    @NSManaged public var streetName: String?
    @NSManaged public var stripSearch: NSNumber
    @NSManaged public var suspectEthnicity: String?
    @NSManaged public var typeCode: String?
    @NSManaged public var latitude: String?
    @NSManaged public var longitude: String?

}
