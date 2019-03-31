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
import MapKit

@objc(Crime)
public class Crime: NSManagedObject, Updatable, Locatable, Annotable {

    
    var colour: UIColor {
        return self.category?.colour ?? .red
    }
    
    public var coordinate: CLLocationCoordinate2D {
        
        return CLLocationCoordinate2D(latitude: latitude!.doubleValue , longitude: longitude!.doubleValue)
    }
    
    public var title: String? {
        return self.category?.description
    }
    
    public var subtitle: String? {
        
        return ""
    }
    

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
    
    
     func update(with json: JSON) {
        
        self.identifier = json[Key.id].number!.stringValue
        self.categoryCode = json[Key.category].string
        self.persistentId = json[Key.persistentId].string
        self.extraContent = json[Key.context].string
        self.locationTypeCode = json[Key.locationType].string
        self.locationSubtypeCode = json[Key.locationSubtype].string
        self.streetName = json[Key.location][Key.streetName.street][Key.streetName.name].string
        self.latitude = json[Key.location][Key.latitude].string.number
        self.longitude = json[Key.location][Key.longitude].string.number
        if let period = DatePeriod(fromMonth: json[Key.date].string) {
            self.month = period.month
            self.year = period.year
        }
        
        self.addOutcomes(from: json[Key.latestOutcome].array)
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

    

