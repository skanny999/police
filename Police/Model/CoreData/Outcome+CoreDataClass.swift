//
//  Outcome+CoreDataClass.swift
//  Police
//
//  Created by Riccardo on 23/01/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Outcome)
public class Outcome: NSManagedObject {
    
    struct Key {
        let category = "category"
        let categoryCode = "code"
        let categoryName = "name"
        let date = "date"
        let personId = "person_id"
    }

}
