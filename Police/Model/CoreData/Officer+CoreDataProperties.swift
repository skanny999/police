//
//  Officer+CoreDataProperties.swift
//  Police
//
//  Created by Riccardo on 23/01/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//
//

import Foundation
import CoreData


extension Officer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Officer> {
        return NSFetchRequest<Officer>(entityName: "Officer")
    }

    @NSManaged public var bio: String?
    @NSManaged public var name: String?
    @NSManaged public var rank: String?
    @NSManaged public var contact: Contact?
    @NSManaged public var force: Force?
    @NSManaged public var neighbourhood: Neighbourhood?

}
