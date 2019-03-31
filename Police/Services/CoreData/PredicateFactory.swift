//
//  PredicateFactory.swift
//  Police
//
//  Created by Riccardo on 21/03/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import Foundation
import MapKit


class PredicateFactory {
    
    static func predicateForMap(_ rect: MKMapRect, excluding crimes: [Crime]) -> NSPredicate {
        
        let topLat = rect.coordinates.topLeft.latitude.short
        let topLong = rect.coordinates.topLeft.longitude.short
        let bottomLat = rect.coordinates.bottomRight.latitude.short
        let bottomLong = rect.coordinates.bottomRight.longitude.short

        
        return NSPredicate(format: "latitude <= %f AND longitude >= %f AND latitude >= %f AND longitude <= %f AND (NOT SELF IN %@)", topLat, topLong, bottomLat, bottomLong, crimes)
    }
    
    
    static func selectedPeriod() -> NSPredicate {
        
        return NSPredicate(format: "isSelected == 1")
    }
    
    static func polygon(forPeriod period: Period) -> NSPredicate? {
        
        return NSPredicate(format: "period == %@", period.stringDescription)
    }
    
}
