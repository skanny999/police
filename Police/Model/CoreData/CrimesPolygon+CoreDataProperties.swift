//
//  CrimesPolygon+CoreDataProperties.swift
//  Police
//
//  Created by Riccardo on 28/03/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//
//

import Foundation
import CoreData


extension CrimesPolygon {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CrimesPolygon> {
        return NSFetchRequest<CrimesPolygon>(entityName: "CrimesPolygon")
    }

    @NSManaged public var period: String?
    @NSManaged public var coordinates: NSData?

}
