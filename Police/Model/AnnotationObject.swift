//
//  File.swift
//  Police
//
//  Created by Riccardo Scanavacca on 18/03/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import Foundation
import MapKit

@objc protocol Annotable: MKAnnotation {
    
    var colour: UIColor { get }
    var image: UIImage { get }
}

//class Annotation: NSObject, Annotable {
//    
//    var coordinate: CLLocationCoordinate2D
//    var title: String?
//    var subtitle: String?
//    
//    var colour: UIColor
//    
//    var origin: Managed?
//    
//    init(with object: Annotable) {
//        
//        self.title = object.title ?? ""
//        self.coordinate = object.coordinate
//        self.colour = object.colour
//        self.origin = object as? Managed
//        
//        super.init()
//    }
//    
//    
//    
//}
