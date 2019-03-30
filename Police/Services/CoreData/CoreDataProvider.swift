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

        return try? context.fetch(fetchRequest)
    }
    
//    static func allPeriods() -> [Period] {
//        
//        let context = CoreDataManager.shared().container.viewContext
//        
//    }
//    
//    static func selectedPeriod() -> Period {
//        
//        
//        
//    }
//    
//    static func lastPeriod() -> Period {
//        
//        
//    }
    
}
