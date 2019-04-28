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
        static let crime = "Crime"
        static let crimeNoOutcome = "CrimeNoOutcome"
        static let crimeEdited = "CrimeEdited"
        static let outcomes = "Outcomes"
        static let outcome = "Outcome"
    }
    
    struct Neighbourhood {
        static let specificNeighbourhood = "Neighbourhood"
        static let neighbourhoodEdited = "NeighbourhoodEdited"
    }
    
    struct Boudaries {
        static let neighbourhoodBoundaries = "NeighbourhoodBoundaries"
    }
    
    struct Events {
        static let events = "Events"
    }
    
    struct Contacts {
        static let allContacts = "AllContacts"
        static let partialContacts = "PartialContacts"
    }
    
    struct Priorities {
        static let priorities = "Priorities"
    }
    
    struct Officers {
        static let officers = "Officers"
    }
    
    struct StopAndSearch {
        static let original = "StopAndSearch"
        static let edited = "StopAndSearchEdited"
    }
}
