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

protocol Managed: class, NSFetchRequestResult {

    static var dataIdentifier: String { get set }
    
    static var entityName: String { get }
    static var defaultSortDescriptors: [NSSortDescriptor] { get }
    
    static func managedObject(withData data: Data, in context: NSManagedObjectContext)
    static func update(_ object: Self, with json: JSON)
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
    
    static func managedObject(withData data: Data, in context: NSManagedObjectContext) {
        
        let objectData = try! JSON(data: data)
        
        guard let objectId = objectData.dictionary?[dataIdentifier]?.number?.stringValue else { return }
        
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

        request.predicate = NSPredicate(format: "identifier == %@", id)
        return request as! NSFetchRequest<NSFetchRequestResult>
    }
    
    static var entityName: String {
        return entity().name!
    }
}
