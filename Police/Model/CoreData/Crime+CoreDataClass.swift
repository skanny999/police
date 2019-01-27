//
//  Crime+CoreDataClass.swift
//  Police
//
//  Created by Riccardo on 23/01/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Crime)
public class Crime: NSManagedObject {
    
    struct Key {
        let category = "category"
        let id = "id"
        let persistentId = "persistent_id"
        let locationType = "location_type"
        let locationSubtype = "location_subtype"
        let date = "month"
        
        let location = "location"
        let latestOutcome = "outcome_status"
    }
}
