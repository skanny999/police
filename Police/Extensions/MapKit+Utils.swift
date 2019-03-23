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
    
    var coordinates:(topLeft: CLLocationCoordinate2D, bottomRight: CLLocationCoordinate2D) {
        
        let topLeft = self.origin.coordinate
        let bottomRightPoint = MKMapPoint(x: self.maxX, y: self.maxY)
        let bottomRight = CLLocationCoordinate2D(latitude: bottomRightPoint.coordinate.latitude, longitude: bottomRightPoint.coordinate.longitude)
        
        return (topLeft, bottomRight)
    }
    
    var coordinatesString: String {
        
        let nw = self.coordinates.topLeft
        let ne = CLLocationCoordinate2D(latitude: self.coordinates.topLeft.latitude, longitude: self.coordinates.bottomRight.longitude)
        let se = self.coordinates.bottomRight
        let sw = CLLocationCoordinate2D(latitude: self.coordinates.bottomRight.latitude, longitude: self.coordinates.topLeft.longitude)
        
        return "\(nw.latitude.short),\(nw.longitude.short):\(ne.latitude.short),\(ne.longitude.short):\(se.latitude.short),\(se.longitude.short):\(sw.latitude.short),\(sw.longitude.short)"
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
