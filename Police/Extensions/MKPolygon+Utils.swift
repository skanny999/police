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
    
}
