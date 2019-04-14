//
//  CrimeAnnotationView.swift
//  Police
//
//  Created by Riccardo on 18/03/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import UIKit
import MapKit

class CrimeAnnotationView: MKMarkerAnnotationView {

    static let reuseID = "crimeAnnotation"
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        if let annotation = annotation as? Annotable {
            markerTintColor = annotation.colour
            clusteringIdentifier = "crime"
        }
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        displayPriority = .defaultHigh
    }
}