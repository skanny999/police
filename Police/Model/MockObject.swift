//
//  File.swift
//  Police
//
//  Created by Riccardo Scanavacca on 18/03/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import Foundation

import MapKit

class Mock: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    
    var title: String?
    var subtitle: String?
    
    init(withAnnotation annotation: MKAnnotation) {
        
        self.title = annotation.title ?? ""
        self.coordinate = annotation.coordinate
        super.init()
    }
    
    
    
}
