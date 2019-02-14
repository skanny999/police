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
import SwiftyJSON

@objc(Crime)
public class Crime: NSManagedObject, Updatable, Locatable {

    static var dataIdentifier: String = "id"
    static var objectIdentifier: String = "identifier"
    
    struct Key {
        
        static let category = "category"
        static let id = "id"
        static let persistentId = "persistent_id"
        static let date = "month"
        
        static let locationType = "location_type"
        static let locationSubtype = "location_subtype"
        static let latitude = "latitude"
        static let longitude = "longitude"
        
        static let location = "location"
        static let streetName = (street: "street", name: "name")
        static let latestOutcome = "outcome_status"
    }
    
    
     static func update(_ object: Crime, with json: JSON) {
        
        object.identifier = json[Key.id].number!.stringValue
        object.categoryCode = json[Key.category].string
        object.persistentId = json[Key.persistentId].string
        object.month = json[Key.date].string
        object.locationTypeCode = json[Key.locationType].string
        object.locationSubtypeCode = json[Key.locationSubtype].string
        object.streetName = json[Key.location][Key.streetName.street][Key.streetName.name].string
        object.latitude = json[Key.location][Key.latitude].string
        object.longitude = json[Key.location][Key.longitude].string
        
    }
}

    

