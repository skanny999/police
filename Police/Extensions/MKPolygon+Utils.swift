//
//  MKPolygon+Utils.swift
//  Police
//
//  Created by Riccardo on 28/03/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import Foundation

extension MKPolygon {
    
    func contains(point: CLLocationCoordinate2D) -> Bool {
        
        let renderer = MKPolygonRenderer(polygon: self)
        let currentMapPoint = MKMapPoint(point)
        let polygonPoint = renderer.point(for: currentMapPoint)
        
        return renderer.path.contains(polygonPoint)
    }
    
    static func polygon(from rect: MKMapRect) -> MKPolygon {
        
        var coordinates = [rect.coordinates.topLeft,
                           rect.coordinates.bottomLeft,
                           rect.coordinates.bottomRight,
                           rect.coordinates.topRight]
        
        return MKPolygon(coordinates: &coordinates, count: coordinates.count)
        
    }
    
    
    func contains(mapView: MKMapView) -> Bool {
        
        return self.intersects(mapView.visibleMapRect) && contains(point: mapView.centerCoordinate)
    }
    
    func merge(with polygon: MKPolygon) -> MKPolygon {
        
        return self.fromUnion(with: polygon)
    }
    
    var data: NSData? {
        
        let coordsPointer = UnsafeMutablePointer<CLLocationCoordinate2D>.allocate(capacity: self.pointCount)
        self.getCoordinates(coordsPointer, range: NSMakeRange(0, self.pointCount))
        
        var points: [PointCoordinates] = []
        
        for i in 0..<self.pointCount {
            let latitude = coordsPointer[i].latitude
            let longitude = coordsPointer[i].longitude
            points.append(PointCoordinates(latitude: latitude, longitude: longitude))
        }
        
        do {
            return try NSKeyedArchiver.archivedData(withRootObject: points as Array, requiringSecureCoding: false) as NSData
        } catch  {
            print("Error archiving polygon: \(error)")
            return nil
        }
    }
    
}
