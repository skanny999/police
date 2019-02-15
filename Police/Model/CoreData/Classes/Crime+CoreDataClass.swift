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
    
    var category: CrimeCategory? {
        
        guard let code = self.categoryCode else { return nil }
        return CrimeCategory(rawValue: code)
    }
    
    struct Key {
        
        static let category = "category"
        static let id = "id"
        static let persistentId = "persistent_id"
        static let date = "month"
        static let context = "context"
        
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
        object.extraContent = json[Key.context].string
        object.locationTypeCode = json[Key.locationType].string
        object.locationSubtypeCode = json[Key.locationSubtype].string
        object.streetName = json[Key.location][Key.streetName.street][Key.streetName.name].string
        object.latitude = json[Key.location][Key.latitude].string
        object.longitude = json[Key.location][Key.longitude].string
        if let period = Period(fromMonth: json[Key.date].string) {
            object.month = period.month
            object.year = period.year
        }
        
        object.addOutcomes(from: json[Key.latestOutcome].array)
    }
    
    func addOutcomes(from jsons: [JSON]?) {
        
        guard let outcomeJsons = jsons else { return }
        
        for json in outcomeJsons {
            
            if let currentOutcomes = self.outcomes, !currentOutcomes.isEmpty {
                
                if !currentOutcomes.contains { $0.date == json["date"].string } {
                    self.addToOutcomes(Outcome.newOutcome(from: json, in: self.managedObjectContext!))
                }
                
            } else {
                
                self.addToOutcomes(Outcome.newOutcome(from: json, in: self.managedObjectContext!))
            }
        }
    }
}

    

