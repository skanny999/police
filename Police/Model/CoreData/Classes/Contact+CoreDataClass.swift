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
    
    var hasNoContacts: Bool {
        
        return  self.address == nil &&
                self.blog == nil &&
                self.email == nil &&
                self.eMessaging == nil &&
                self.facebook == nil &&
                self.fax == nil &&
                self.flickr == nil &&
                self.forum == nil &&
                self.googlePlus == nil &&
                self.mobile == nil &&
                self.rss == nil &&
                self.telephone == nil &&
                self.twitter == nil &&
                self.website == nil &&
                self.youtube == nil 
    }
    
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
        static let youtube = "youtube"
        static let contacts = "contact_details"
        static let links = "links"
        static let url = "url"
        static let urlForce = "url_force"
    }
    
    static func newContacts(from json: JSON?, in context: NSManagedObjectContext) -> Contact? {
        
        guard let contactJson = json else { return nil }
        let contacts = Contact(entity: Contact.entity(), insertInto: context)
        contacts.updateContacts(fromContactDetails: contactJson)
        return contacts
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
    
    
    func updateContacts(fromContactDetails json: JSON?) {
        
        self.twitter = json?[Key.twitter].string
        self.facebook = json?[Key.facebook].string
        self.telephone = json?[Key.telephone].string
        self.email = json?[Key.email].string
        self.address = json?[Key.address].string
        self.blog = json?[Key.blog].string
        self.eMessaging = json?[Key.eMessaging].string
        self.fax = json?[Key.fax].string
        self.flickr = json?[Key.flickr].string
        self.forum = json?[Key.forum].string
        self.googlePlus = json?[Key.googlePlus].string
        self.mobile = json?[Key.mobile].string
        self.rss = json?[Key.rss].string
        self.website = json?[Key.website].string
        self.youtube = json?[Key.youtube].string
    }

    
    private func parseNeighbourhoodContact(from json: JSON) {
        self.forceUrl = json[Key.urlForce].string
        updateContacts(fromContactDetails: json[Key.contacts])
        //override website
        self.website = json[Key.links].array?.first?[Key.url].string
    }
    


}
