//
//  MapKit+Utils.swift
//  Police
//
//  Created by Riccardo Scanavacca on 15/03/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import Foundation
import MapKit

extension MKMapRect {
    
    var coordinates:(topLeft: CLLocationCoordinate2D, bottomLeft: CLLocationCoordinate2D, bottomRight: CLLocationCoordinate2D, topRight: CLLocationCoordinate2D) {
        
        let topLeft = self.origin.coordinate
        let bottomRightPoint = MKMapPoint(x: self.maxX, y: self.maxY)
        let bottomLeftPoint = MKMapPoint(x: self.minX, y: self.maxY)
        let topRightPoint = MKMapPoint(x: self.maxX, y: self.minY)
        let bottomRight = CLLocationCoordinate2D(latitude: bottomRightPoint.coordinate.latitude, longitude: bottomRightPoint.coordinate.longitude)
        let bottomLeft = CLLocationCoordinate2D(latitude: bottomLeftPoint.coordinate.latitude, longitude: bottomLeftPoint.coordinate.longitude)
        let topRight = CLLocationCoordinate2D(latitude: topRightPoint.coordinate.latitude, longitude: topRightPoint.coordinate.longitude)
        return (topLeft, bottomLeft, bottomRight, topRight)
    }
    
    var coordinatesString: String {
        
        let nw = self.coordinates.topLeft
        let ne = CLLocationCoordinate2D(latitude: self.coordinates.topLeft.latitude, longitude: self.coordinates.bottomRight.longitude)
        let se = self.coordinates.bottomRight
        let sw = CLLocationCoordinate2D(latitude: self.coordinates.bottomRight.latitude, longitude: self.coordinates.topLeft.longitude)
        
        return "\(nw.latitude.short),\(nw.longitude.short):\(ne.latitude.short),\(ne.longitude.short):\(se.latitude.short),\(se.longitude.short):\(sw.latitude.short),\(sw.longitude.short)"
    }

}


extension MKMapView {
    
    var zoomLevel: Int {

        return Int(self.visibleMapRect.size.width / Double(self.frame.size.width))
    }
    
    var visibleRectPolygon: MKPolygon {
        
        let coordinates = [self.visibleMapRect.coordinates.topLeft,
                           self.visibleMapRect.coordinates.bottomLeft,
                           self.visibleMapRect.coordinates.bottomRight,
                           self.visibleMapRect.coordinates.topRight]
        
        return MKPolygon(coordinates: coordinates, count: coordinates.count)
    }
    
}

extension MKAnnotationView {
    
    func view(forAnnotation annotation: MKAnnotation) -> MKAnnotationView {
        
        self.tintColor = .purple
        self.isEnabled = true
        self.canShowCallout = true
        self.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        self.annotation = annotation
        self.image = UIImage(named: "Circle-orange")
        
        return self
    }
    

}
