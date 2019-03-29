//
//  PointCoordinates.swift
//  Police
//
//  Created by Riccardo on 28/03/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import UIKit
import Foundation

class PointCoordinates: NSObject, NSSecureCoding {
    
    static var supportsSecureCoding: Bool = true
    
    private static let keyLatitude = "latitude_key"
    private static let keyLongitude = "longitude_key"
    
    var latitude: Double
    var longitude: Double
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(latitude, forKey: PointCoordinates.keyLatitude)
        aCoder.encode(longitude, forKey: PointCoordinates.keyLongitude)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.latitude = aDecoder.decodeDouble(forKey: PointCoordinates.keyLatitude)
        self.longitude = aDecoder.decodeDouble(forKey: PointCoordinates.keyLongitude)
    }

}
