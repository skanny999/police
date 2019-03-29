//
//  CrimesPolygon+CoreDataClass.swift
//  Police
//
//  Created by Riccardo on 28/03/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//
//

import Foundation
import CoreData
import MapKit
import CoreLocation

@objc(CrimesPolygon)
public class CrimesPolygon: NSManagedObject {
    
    func createCrimesPolygon(from polygon: MKPolygon, in context: NSManagedObjectContext) {
        
        let crimePolygon = CrimesPolygon(entity: CrimesPolygon.entity(), insertInto: context)
        crimePolygon.coordinates = coordinatesData(from: polygon)
        crimePolygon.period = "03-2019"
    }
    

}

extension CrimesPolygon {
    
    func coordinatesData(from polygon: MKPolygon) -> NSData? {
        
        var points: [PointCoordinates] = []
        for point in UnsafeBufferPointer(start: polygon.points(), count: polygon.pointCount) {
            points.append(PointCoordinates(latitude: point.x, longitude: point.y))
        }
        
        do {
            return try NSKeyedArchiver.archivedData(withRootObject: points as Array, requiringSecureCoding: false) as NSData
        } catch  {
            print(error)
            return nil
        }
    }
    
    var mapPolygon: MKPolygon? {
        
        guard let coordinates = coordinates as Data? else { return nil }
        
        do {
            let points = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self, PointCoordinates.self] , from: coordinates)
            
            return polygon(from: points as! [PointCoordinates])
            
        } catch  {
            print(error)
            return nil
        }
    }
    
    func polygon(from points: [PointCoordinates]) -> MKPolygon {
        
        var coordinates: [CLLocationCoordinate2D] = []
        for point in points {
            let pointCoordinates = CLLocationCoordinate2DMake(point.latitude, point.longitude)
            coordinates.append(pointCoordinates)
        }
        return MKPolygon(coordinates: &coordinates, count: coordinates.count)
    }
    
    
}
