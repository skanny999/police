//
//  Contact+CoreDataClass.swift
//  Police
//
//  Created by Riccardo on 23/01/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//
//

import Foundation
import CoreData
import SwiftyJSON

@objc(Contact)
public class Contact: NSManagedObject {
    
    struct Key {
        
        static let address = "address"
        static let blog = "blog"
        static let email = "email"
        static let eMessaging = "e-messaging"
        static let facebook = "facebook"
        static let fax = "fax"
        static let flickr = "flickr"
        static let forum = "forum"
        static let googlePlus = "google-plus"
        static let mobile = "mobile"
        static let rss = "rss"
        static let telephone = "telephone"
        static let twitter = "twitter"
        static let website = "web"
        static let url = "url"
        static let urlForce = "url_force"
        static let youtube = "youtube"
        static let contacts = "contact_details"
        static let links = "links"
    }
    
    static func updateContacts(for neighbourhood: Neighbourhood, with json: JSON) {
        
        if let contact = neighbourhood.contact {
            
            contact.parseNeighbourhoodContact(from: json)
            
        } else {
            
            let contact = Contact(entity: Contact.entity(), insertInto: neighbourhood.managedObjectContext)
            contact.parseNeighbourhoodContact(from: json)
            neighbourhood.contact = contact
        }
    }
    
    func parseNeighbourhoodContact(from json: JSON) {
        
        self.twitter = json[Key.contacts][Key.twitter].string
        self.facebook = json[Key.contacts][Key.facebook].string
        self.telephone = json[Key.contacts][Key.telephone].string
        self.email = json[Key.contacts][Key.email].string
        self.forceUrl = json[Key.urlForce].string
        self.website = json[Key.links].array?.first?[Key.url].string
    }

}
