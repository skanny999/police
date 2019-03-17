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
import SwiftyJSON

@objc(Place)
public class Place: NSManagedObject, Locatable {
    
    struct Key {
        static let name = "name"
        static let postcode = "postcode"
        static let address = "address"
        static let type = "type"
        static let description = "description"
        static let latitude = "latitude"
        static let longitude = "longitude"
    }
    
    class func createPlace(from json: JSON, in context: NSManagedObjectContext?) -> Place {
        
        let place = Place(entity: Place.entity(), insertInto: context)
        place.updatePlace(from: json)
        return place
    }
    
    
    func updatePlace(from json: JSON) {
        
        self.name = json[Key.name].string
        self.postcode = json[Key.postcode].string
        self.address = json[Key.address].string
        self.typeCode = json[Key.type].string
        self.longDescription = json[Key.description].string
        self.latitude = json[Key.latitude].string
        self.longitude = json[Key.longitude].string
    }
}
