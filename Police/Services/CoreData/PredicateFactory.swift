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
    
    static func predicateForMap(_ mapview: MKMapView, excluding annotations: [Annotation]) -> NSPredicate {
        
        let topLat = mapview.visibleMapRect.coordinates.topLeft.latitude.short
        let topLong = mapview.visibleMapRect.coordinates.topLeft.longitude.short
        let bottomLat = mapview.visibleMapRect.coordinates.bottomRight.latitude.short
        let bottomLong = mapview.visibleMapRect.coordinates.bottomRight.longitude.short
        var crimes:[Crime] = []
        for annotation in annotations {
            if let crime = annotation.origin as? Crime {
                crimes.append(crime)
            }
        }
        
        return NSPredicate(format: "latitude <= %f AND longitude >= %f AND latitude >= %f AND longitude <= %f AND (NOT SELF IN %@)", topLat, topLong, bottomLat, bottomLong, crimes)
    }
    
}
