//
//  Place+CoreDataClass.swift
//  Police
//
//  Created by Riccardo on 23/01/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Place)
public class Place: NSManagedObject {
    
    struct Key {
        let name = "name"
        let postcode = "postcode"
        let address = "address"
        let type = "type"
        let description = "description"
    }
    
}
