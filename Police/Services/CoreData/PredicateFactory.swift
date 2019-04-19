//
//  PredicateFactory.swift
//  Police
//
//  Created by Riccardo on 21/03/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import Foundation
import MapKit
import CoreData


class PredicateFactory {
    
    static func crimesForMap(_ rect: MKMapRect, excluding crimes: [Crime]) -> NSPredicate {
        
        return predicateForMap(rect, excluding: crimes)
    }
    
    static func stopAndSearchForMap(_ rect: MKMapRect, excluding sas: [StopAndSearch]) -> NSPredicate {
        
        return predicateForMap(rect, excluding: sas)
    }
    
    static func neighbourhood(withId identifier: String) -> NSPredicate {
        
        return NSPredicate(format: "identifier == %@", identifier)
    }
    
    private static func predicateForMap<T: NSManagedObject>(_ rect: MKMapRect, excluding objects: [T]) -> NSPredicate {
        
        let topLat = rect.coordinates.topLeft.latitude.short
        let topLong = rect.coordinates.topLeft.longitude.short
        let bottomLat = rect.coordinates.bottomRight.latitude.short
        let bottomLong = rect.coordinates.bottomRight.longitude.short
        #warning("Add current period parameter")
        return NSPredicate(format: "latitude <= %f AND longitude >= %f AND latitude >= %f AND longitude <= %f AND (NOT SELF IN %@)", topLat, topLong, bottomLat, bottomLong, objects)
    }
    
    
    static func selectedPeriod() -> NSPredicate {
        
        return NSPredicate(format: "isSelected == 1")
    }
    
    static func polygon(forPeriod period: Period) -> NSPredicate? {
        
        return NSPredicate(format: "period == %@", period.stringDescription)
    }
    
}
