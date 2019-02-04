//
//  Contact+CoreDataProperties.swift
//  Police
//
//  Created by Riccardo on 23/01/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//
//

import Foundation
import CoreData


extension Contact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact")
    }
    
    //delete and parse
    
    @NSManaged public var address: String?
    @NSManaged public var blog: String?
    @NSManaged public var email: String?
    @NSManaged public var eMessaging: String?
    @NSManaged public var facebook: String?
    @NSManaged public var fax: String?
    @NSManaged public var flickr: String?
    @NSManaged public var forum: String?
    @NSManaged public var googlePlus: String?
    @NSManaged public var mobile: String?
    @NSManaged public var rss: String?
    @NSManaged public var telephone: String?
    @NSManaged public var twitter: String?
    @NSManaged public var website: String?
    @NSManaged public var youtube: String?
    @NSManaged public var event: Event?
    @NSManaged public var force: Force?
    @NSManaged public var neighbourhood: Neighbourhood?
    @NSManaged public var officer: Officer?

}
