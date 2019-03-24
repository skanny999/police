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
    
    
    static func crimesWithin(mapView: MKMapView, excluding annotations: [Annotation]) -> [Crime]? {
        
        let context = CoreDataManager.shared().container.viewContext
        
        let fetchRequest = Crime.sortedFetchRequest
        fetchRequest.predicate = PredicateFactory.predicateForMap(mapView, excluding: annotations)
        print(fetchRequest.predicate!)
        let crimes = try? context.fetch(fetchRequest)
        
        return crimes
    }
    
}
