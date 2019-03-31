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
        fetchRequest.predicate = PredicateFactory.crimesForMap(mapViewArea, excluding: crimes)
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Couldn't fetch crimes: \(error.localizedDescription)")
            return nil
        }
    }
    
    static func stopAndSearch(mapViewArea: MKMapRect, excluding currentAnnotations: [Annotable]) -> [StopAndSearch]? {
        let sasOnMap = currentAnnotations.compactMap { $0 as? StopAndSearch }
        let context = CoreDataManager.shared.container.viewContext
        let fetchRequest = StopAndSearch.sortedFetchRequest
        fetchRequest.predicate = PredicateFactory.stopAndSearchForMap(mapViewArea, excluding: sasOnMap)
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Couldn't fetch crimes: \(error.localizedDescription)")
            return nil
        }
    }
    
    static func currentPolygon() -> MKPolygon? {
        
        guard let selectedPeriod = CoreDataProvider.selectedPeriod() else { return nil }
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CrimePolygon")
        request.sortDescriptors = []
        request.predicate = PredicateFactory.polygon(forPeriod: selectedPeriod)
        
        let context = CoreDataManager.shared.container.viewContext
        
        do {
            if let crimePolygone = try context.fetch(request).first as? CrimesPolygon {
                return crimePolygone.mapPolygon
            } else {
                return nil
            }
            
        } catch  {
            print("Error retrieving polygone: \(error.localizedDescription)")
            return nil
        }
    }
    

    
}

// MARK: - Period

extension CoreDataProvider {
    
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
            return try (context.fetch(periodFetchRequest(predicate: PredicateFactory.selectedPeriod())).first as? Period)
        } catch {
            print("Couldn't fetch selected period: \(error.localizedDescription)")
        }
        return self.lastPeriod()
    }
    
    static func lastPeriod() -> Period? {
        
        let context = CoreDataManager.shared.container.viewContext
        do {
            return try context.fetch(periodFetchRequest(predicate: nil)).first as? Period
        } catch {
            print("Couldn't fetch last period: \(error.localizedDescription)")
        }
        return nil
    }
    
    private static func periodFetchRequest(predicate: NSPredicate?) -> NSFetchRequest<NSFetchRequestResult> {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Period")
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        request.predicate = predicate
        return request
    }
    
    
}
