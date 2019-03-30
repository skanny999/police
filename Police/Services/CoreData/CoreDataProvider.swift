//
//  CoreDataProvider.swift
//  Police
//
//  Created by Riccardo on 21/03/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import Foundation
import CoreData
import MapKit

class CoreDataProvider {
    
    
    static func crimesWithin(mapViewArea: MKMapRect, excluding currentAnnotations: [Annotable]) -> [Crime]? {
        
        let crimes = currentAnnotations.compactMap { $0 as? Crime }
        let context = CoreDataManager.shared.container.viewContext
        let fetchRequest = Crime.sortedFetchRequest
        fetchRequest.predicate = PredicateFactory.predicateForMap(mapViewArea, excluding: crimes)
        print(fetchRequest.predicate!)
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Couldn't fetch crimes: \(error.localizedDescription)")
            return nil
        }
    }
    
    static func allPeriods() -> [Period]? {
        
        let context = CoreDataManager.shared.container.viewContext
        
        do {
            return try context.fetch(periodFetchRequest(predicate: nil)) as? [Period]
        } catch {
            print("Couldn't fetch all periods: \(error.localizedDescription)")
            return nil
        }
    }
    
    static func selectedPeriod() -> Period? {
        
        let context = CoreDataManager.shared.container.viewContext
        do {
            return try context.fetch(periodFetchRequest(predicate: PredicateFactory.selectedPeriod())).first as? Period ?? self.lastPeriod()
        } catch {
            print("oCuldn't fetch selected period: \(error.localizedDescription)")
        }
        return self.lastPeriod()
    }
    
    static func lastPeriod() -> Period? {
        
        let context = CoreDataManager.shared.container.viewContext
        do {
            return try context.fetch(periodFetchRequest(predicate: nil)).first as? Period ?? nil
        } catch {
            print("Culdn't fetch last period: \(error.localizedDescription)")
        }
        return nil
    }
    
    private static func periodFetchRequest(predicate: NSPredicate?) -> NSFetchRequest<NSFetchRequestResult> {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Period")
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        request.predicate = predicate
        return request
    }
    
}
