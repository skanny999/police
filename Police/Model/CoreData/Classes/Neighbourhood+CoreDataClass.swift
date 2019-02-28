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
    }

    func updatePlaces(from json: [JSON]?) {
        
        guard let locationsJson = json else { return }
        
        for location in locationsJson {
            
            if let currentLocations = self.places, !currentLocations.isEmpty {
                
                if !currentLocations.contains { $0.name == location["name"].string } {
                    self.addToPlaces(Place.createPlace(from: location, in: managedObjectContext))
                }
                
            } else {
                
                self.addToPlaces(Place.createPlace(from: location, in: managedObjectContext))
            }
        }
    }
    
    #warning("check if events will return an empty array")
    
    func addEvents(from jsons: [JSON]?) {
        
        eraseCurrent(elements: self.events)
        processJsons(jsons) { [weak self] (json) in
            self?.addToEvents(Event.createEvent(from: json, in: managedObjectContext))
        }
    }
    
    func addPriorities(from jsons: [JSON]?) {
        
        eraseCurrent(elements: self.priorities)
        processJsons(jsons) { [weak self] (json) in
            self?.addToPriorities(Priority.createPriority(from: json, in: managedObjectContext))
        }
    }
    
    func addOfficers(form jsons: [JSON]?) {
        
        eraseCurrent(elements: self.officers)
        processJsons(jsons) { [weak self] (json) in
            self?.addToOfficers(Officer.createOfficer(from: json, in: managedObjectContext))
        }
    }
    
    func processJsons(_ jsons: [JSON]?, completion: (JSON) -> Void) {
        
        if let objectsJsons = jsons {
            for json in objectsJsons {
                completion(json)
            }
        }
    }
    
    func eraseCurrent<T: NSManagedObject>(elements: Set<T>?) {
        
        if let elements = elements, !elements.isEmpty {
            for element in elements {
                managedObjectContext?.delete(element)
            }
        }
    }
}
