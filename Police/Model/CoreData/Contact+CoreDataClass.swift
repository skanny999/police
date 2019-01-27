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

@objc(Contact)
public class Contact: NSManagedObject {
    
    struct Key {
        
        let address = "address"
        let blog = "blog"
        let email = "email"
        let eMessaging = "e-messaging"
        let facebook = "facebook"
        let fax = "fax"
        let flickr = "flickr"
        let forum = "forum"
        let googlePlus = "google-plus"
        let mobile = "mobile"
        let rss = "rss"
        let telephone = "telephone"
        let twitter = "twitter"
        let website = "web"
        let youtube = "youtube"
    }

}
