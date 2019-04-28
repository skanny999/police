//
//  NSData+poly.swift
//  Police
//
//  Created by Riccardo on 02/04/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import Foundation

extension NSData {
    
    var polygon: MKPolygon? {
        
        do {
            let points = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self, PointCoordinates.self] , from: self as Data)
            
            return polygon(from: points as! [PointCoordinates])
            
        } catch  {
            print("Error unarchiving polygon: \(error)")
            return nil
        }
        
    }
    
    private func polygon(from points: [PointCoordinates]) -> MKPolygon {
        
        var locations: [CLLocationCoordinate2D] = []
        for point in points {
            let pointCoordinates = CLLocationCoordinate2DMake(point.latitude, point.longitude)
            locations.append(pointCoordinates)
        }
        
        return MKPolygon(coordinates: &locations, count: locations.count)
    }
    
    
}
