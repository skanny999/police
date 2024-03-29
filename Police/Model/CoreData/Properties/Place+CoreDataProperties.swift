//
//  Place+CoreDataProperties.swift
//  Police
//
//  Created by Riccardo on 23/01/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//
//

import Foundation
import CoreData


extension Place {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Place> {
        return NSFetchRequest<Place>(entityName: "Place")
    }
    
    //delete and parse
    @NSManaged public var address: String?
    @NSManaged public var longDescription: String?
    @NSManaged public var name: String?
    @NSManaged public var postcode: String?
    @NSManaged public var telephone: String?
    @NSManaged public var typeCode: String?
    @NSManaged public var latitude: NSNumber?
    @NSManaged public var longitude: NSNumber?
    @NSManaged public var neighbourhood: Neighbourhood?

}
