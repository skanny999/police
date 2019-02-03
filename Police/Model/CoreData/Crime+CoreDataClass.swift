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
public class Crime: NSManagedObject, Managed {
    
    struct Key {
        
        static let category = "category"
        static let id = "id"
        static let persistentId = "persistent_id"
        static let date = "month"
        
        static let locationType = "location_type"
        static let locationSubtype = "location_subtype"
        
        static let location = "location"
        static let latestOutcome = "outcome_status"
    }
    
    
    fileprivate static func update(_ crime: Crime, with crimeJson: JSON) {
        
        crime.identifier = crimeJson[Key.id].number!
        crime.categoryCode = crimeJson[Key.category].string
        crime.persistentId = crimeJson[Key.persistentId].string
        crime.month = crimeJson[Key.date].string
        crime.locationTypeCode = crimeJson[Key.locationType].string
        crime.locationSubtypeCode = crimeJson[Key.locationSubtype].string
    }
    
    static func crime(withData data: Data, in context: NSManagedObjectContext) {

        let crimeData = try! JSON(data: data)
        
        guard let crimeId = crimeData.dictionary?[Key.id]?.number else { return }
        
        if let crime = Crime.crime(withId: crimeId) {
            
            update(crime, with: crimeData)
            
        } else {
            
            let crime = Crime(entity: self.entity(), insertInto: context)
            
            update(crime, with: crimeData)
        }
    }
    
    
    static func crime(withId id: NSNumber) -> Crime? {
        
        return try! CoreDataManager.shared().container.viewContext.fetch(fetchRequest(forCrimeId: id)).first as? Crime
    }
    
    
    private static func crime(withId id: NSNumber, inContext context: NSManagedObjectContext) -> Crime? {

        return try! context.fetch(fetchRequest(forCrimeId: id)).first as! Crime
    }
    
    private static func fetchRequest(forCrimeId id: NSNumber) -> NSFetchRequest<NSFetchRequestResult> {
        
        let request = self.sortedFetchRequest
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(Crime.identifier), id)
        return request as! NSFetchRequest<NSFetchRequestResult>
    }
    
    
    
    
    
    
}

    

