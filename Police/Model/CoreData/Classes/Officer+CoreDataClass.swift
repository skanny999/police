//
//  Officer+CoreDataClass.swift
//  Police
//
//  Created by Riccardo on 23/01/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Officer)
public class Officer: NSManagedObject {
    
    struct Key {
        let name = "name"
        let bio = "bio"
        let rank = "rank"
    }

}
