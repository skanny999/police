//
//  Event+CoreDataClass.swift
//  Police
//
//  Created by Riccardo on 23/01/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Event)
public class Event: NSManagedObject, Locatable {
    
    struct Key {
        let description = "description"
        let title = "title"
        let address = "address"
        let type = "type"
        let startDate = "start_date"
        let endDate = "end_date"
    }
}
