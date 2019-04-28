//
//  Event+CoreDataClass.swift
//  Police
//
//  Created by Riccardo on 23/01/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//
//

import Foundation
import CoreData
import SwiftyJSON

@objc(Event)
public class Event: NSManagedObject, Locatable {
    
    struct Key {
        static let description = "description"
        static let title = "title"
        static let address = "address"
        static let type = "type"
        static let startDate = "start_date"
        static let endDate = "end_date"
        static let contactDetails = "contact_details"
    }
    
    static func createEvent(from json: JSON, in context: NSManagedObjectContext?) -> Event {
        
        let event = Event(entity: Event.entity(), insertInto: context)
        event.longDescription = json[Key.description].string?.stripOutHtml()
        event.title = json[Key.title].string
        event.address = json[Key.address].string
        event.typeCode = json[Key.type].string
        event.startDate = json[Key.startDate].string?.dateValue
        event.endDate = json[Key.endDate].string?.dateValue
        event.contact = Contact.newContacts(from: json[Key.contactDetails], in: context)
        
        return event
    }

}
