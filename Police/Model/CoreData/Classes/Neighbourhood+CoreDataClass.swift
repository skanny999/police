//
//  Neighbourhood+CoreDataClass.swift
//  Police
//
//  Created by Riccardo on 23/01/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//
//

import Foundation
import CoreData
import SwiftyJSON

@objc(Neighbourhood)
public class Neighbourhood: NSManagedObject, Updatable {
    
    struct Key {
        
        static let id = "id"
        static let description = "description"
        static let name = "name"
        static let population = "population"
        static let centre = "centre"
        static let latitude = "latitude"
        static let longitude = "longitude"
    }
    
    static var dataIdentifier: String = Key.id
    static var objectIdentifier: String = "identifier"
    
    static func update(_ object: Neighbourhood, with json: JSON) {
        
        object.identifier = json[Key.id].string
        object.longDescription = json[Key.description].string
        object.name = json[Key.name].string
        object.population = json[Key.population].number
        object.latitude = json[Key.centre][Key.latitude].string
        object.longitude = json[Key.centre][Key.longitude].string
        Contact.updateContacts(for: object, with: json)
        
        //add places
        //add officers
        //add priorities
        //add events
    }
    
    


}
