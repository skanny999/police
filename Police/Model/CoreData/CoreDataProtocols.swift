//
//  CoreDataProtocols.swift
//  Police
//
//  Created by Riccardo on 03/02/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON

// MARK: - Managed protocol

protocol Managed: class, NSFetchRequestResult {

    static var entityName: String { get }
    static var defaultSortDescriptors: [NSSortDescriptor] { get }
    
    static func managedObject(withData data: Data, in context: NSManagedObjectContext)

}

extension Managed {
    
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return []
    }
    
    static var sortedFetchRequest: NSFetchRequest<Self> {
        
        let request = NSFetchRequest<Self>(entityName: entityName)
        request.sortDescriptors = defaultSortDescriptors
        return request
    }
}

extension Managed where Self: NSManagedObject {
    
    static var entityName: String {
        return entity().name!
    }
}

// MARK: - Locatable

protocol Locatable {
    
    var latitude: String? { get set }
    var longitude: String? { get set }
}

extension Locatable {
    
    var coordinates: (lat: String, long: String)? {
        
        guard let lat = latitude, let long = longitude else { return nil }
        return (lat, long)
    }
    
    var hasCoordinates: Bool {
        
        return latitude != nil && longitude != nil
    }
}


// MARK: - Updatable sub protocol

protocol Updatable: Managed {
    
    static var dataIdentifier: String { get set }
    static var objectIdentifier: String { get set }
    
    static func update(_ object: Self, with json: JSON)
    
}

extension Updatable where Self: NSManagedObject {
    
    static func managedObject(withData data: Data, in context: NSManagedObjectContext) {
        
        let objectData = try! JSON(data: data)
        
        guard
            let objectId = objectData.dictionary?[dataIdentifier]?.number?.stringValue
            ?? objectData.dictionary?[dataIdentifier]?.string else { return }
        
        if let object = Self.object(withId: objectId) {
            
            update(object, with: objectData)
            
        } else {
            
            let object = Self(entity: self.entity(), insertInto: context)
            
            update(object, with: objectData)
        }
    }
    
    static func object(withId id: String) -> Self? {
        
        let object = try! CoreDataManager.shared().container.viewContext.fetch(fetchRequest(forId: id)).first as? Self
        return object
    }
    
    private static func fetchRequest(forId id: String) -> NSFetchRequest<NSFetchRequestResult> {
        
        let request = self.sortedFetchRequest

        request.predicate = NSPredicate(format: "%K == %@", objectIdentifier, id)
        return request as! NSFetchRequest<NSFetchRequestResult>
    }
}


