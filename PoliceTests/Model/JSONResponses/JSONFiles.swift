//
//  JSONFiles.swift
//  Police
//
//  Created by Riccardo on 26/01/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import Foundation

struct JSONFile {
    
    struct Forces {
        
        static let list = "ListOfForces"
        static let specific = "SpecificForce"
    }
    
    struct Crimes {
    
        static let crimes = "Crimes"
        static let outcomes = "Outcomes"
        static let outcome = "Outcome"
    }
    
    struct neighbourhood {
        
        static let specificNeighbourhood = "Neighbourhood"
    }
}
