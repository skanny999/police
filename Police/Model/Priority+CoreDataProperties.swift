//
//  Priority+CoreDataProperties.swift
//  Police
//
//  Created by Riccardo on 23/01/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//
//

import Foundation
import CoreData


extension Priority {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Priority> {
        return NSFetchRequest<Priority>(entityName: "Priority")
    }

    @NSManaged public var action: String?
    @NSManaged public var actionDate: NSDate?
    @NSManaged public var issue: String?
    @NSManaged public var issueDate: NSDate?
    @NSManaged public var neighbourhood: Neighbourhood?

}
