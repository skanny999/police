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
    
    func update(with json: JSON) {
        
        self.identifier = json[Key.id].string
        self.longDescription = json[Key.description].string
        self.name = json[Key.name].string
        self.population = json[Key.population].string
        self.latitude = json[Key.centre][Key.latitude].string.number
        self.longitude = json[Key.centre][Key.longitude].string.number
        Contact.updateContacts(for: self, with: json)
        self.updatePlaces(from: json[Key.locations].array)
    }
    
    func addPolygon(from json: [JSON]?) {
        
        guard let polygonJson = json else { return }
        
        var coordinates:[CLLocationCoordinate2D] = []
        for json in polygonJson {
            if let lat = json["latitude"].string,
                let latitude = Double(lat),
                let lon = json["longitude"].string,
                let longitude = Double(lon) {
                
                coordinates.append(CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
            }
            
        }
        

        let polygon = MKPolygon(coordinates: &coordinates, count: coordinates.count)
        self.polygonData = polygon.data
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
