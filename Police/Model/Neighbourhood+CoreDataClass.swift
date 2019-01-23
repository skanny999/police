//
//  Neighbourhood+CoreDataClass.swift
//  Police
//
//  Created by Riccardo on 23/01/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Neighbourhood)
public class Neighbourhood: NSManagedObject {
    
    struct Key {
        let id = "id"
        let description = "description"
        let name = "name"
        let population = "population"
    }

}
