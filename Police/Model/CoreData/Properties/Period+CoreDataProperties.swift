//
//  Period+CoreDataProperties.swift
//  Police
//
//  Created by Riccardo on 30/03/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//
//

import Foundation
import CoreData


extension Period {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Period> {
        return NSFetchRequest<Period>(entityName: "Period")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var isSelected: Bool

}
