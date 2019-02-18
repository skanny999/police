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
public class Neighbourhood: NSManagedObject, Updatable, Locatable {
    
    struct Key {
        
        static let id = "id"
        static let description = "description"
        static let name = "name"
        static let population = "population"
        static let centre = "centre"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let locations = "locations"
    }
    
    static var dataIdentifier: String = Key.id
    static var objectIdentifier: String = "identifier"
    
    static func update(_ object: Neighbourhood, with json: JSON) {
        
        object.identifier = json[Key.id].string
        object.longDescription = json[Key.description].string
        object.name = json[Key.name].string
        object.population = json[Key.population].string
        object.latitude = json[Key.centre][Key.latitude].string
        object.longitude = json[Key.centre][Key.longitude].string
        Contact.updateContacts(for: object, with: json)
        object.updatePlaces(from: json[Key.locations].array)
        
        //add priorities
        //add events
        //add officers
    }

    func updatePlaces(from json: [JSON]?) {
        
        guard let locationsJson = json else { return }
        
        for location in locationsJson {
            
            if let currentLocations = self.places, !currentLocations.isEmpty {
                
                if !currentLocations.contains { $0.name == location["name"].string } {
                    self.addToPlaces(Place.createPlace(for: self, from: location))
                }
                
            } else {
                
                self.addToPlaces(Place.createPlace(for: self, from: location))
            }
        }
    }
    
    func addEvents(from json: [JSON]?) {
        
        if  let events = self.events, !events.isEmpty {
            for event in events {
                self.managedObjectContext?.delete(event)
            }
        }
        
        if let eventsJson = json, let context = self.managedObjectContext {
            for event in eventsJson {
                self.addToEvents(Event.createEvent(from: event, in: context))
            }
        }
    }


}
