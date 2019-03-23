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
    
    static func predicateForMapRect(_ mapRect: MKMapRect) -> NSPredicate {
        
        let topLat = mapRect.coordinates.topLeft.latitude.short
        let topLong = mapRect.coordinates.topLeft.longitude.short
        let bottomLat = mapRect.coordinates.bottomRight.latitude.short
        let bottomLong = mapRect.coordinates.bottomRight.longitude.short
        
        return NSPredicate(format: "latitude <= %f AND longitude >= %f AND latitude >= %f AND longitude <= %f", topLat, topLong, bottomLat, bottomLong)
    }
    
}
