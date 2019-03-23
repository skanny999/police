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
    
    static func crimesWithin(mapRect: MKMapRect, completion: @escaping ([Crime]?) -> Void) {
        
        CoreDataManager.performViewTask({ (context) in
            let fetchRequest = Crime.sortedFetchRequest
            fetchRequest.predicate = PredicateFactory.predicateForMapRect(mapRect)
            let crimes = try? context.fetch(fetchRequest)
            completion(crimes)
        })
    }
    
    static func crimesWithin(mapRect: MKMapRect) -> [Crime]? {
        
        let context = CoreDataManager.shared().container.viewContext
        let fetchRequest = Crime.sortedFetchRequest
        fetchRequest.predicate = PredicateFactory.predicateForMapRect(mapRect)
        print(fetchRequest.predicate!)
        let crimes = try? context.fetch(fetchRequest)
        
        return crimes
    }
    
}
