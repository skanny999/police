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
    
    
    func merge(with polygon: MKPolygon) -> MKPolygon {
        
        return self.fromIntersection(with: polygon)
    }
    
}
