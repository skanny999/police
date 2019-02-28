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
import SwiftyJSON

@objc(Officer)
public class Officer: NSManagedObject {
    
    struct Key {
        static let name = "name"
        static let bio = "bio"
        static let rank = "rank"
        static let contactDetails = "contact_details"
    }
    
    class func createOfficer(from json: JSON, in context: NSManagedObjectContext?) -> Officer {
        
        let officer = Officer(entity: self.entity(), insertInto: context)
        return officer
    }
    
    func updateOfficer(with json: JSON) {
        
        self.name = json[Key.name].string
        self.rank = json[Key.rank].string
        self.bio = json[Key.bio].string?.stripOutHtml()
        self.contact = Contact.newContacts(from: json, in: self.managedObjectContext)
    }

}
