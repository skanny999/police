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
    }
    
    static func createEvent(from json: JSON, in context: NSManagedObjectContext) -> Event {
        
        let event = Event(entity: Event.entity(), insertInto: context)
        event.longDescription = json[Key.description].string?.stripOutHtml()
        event.title = json[Key.title].string
        event.address = json[Key.address].string
        event.typeCode = json[Key.type].string
        event.startDate = date(fromString: json[Key.startDate].string)
        event.endDate = date(fromString: json[Key.endDate].string)
        return event
    }
    
    private static func date(fromString string: String?) -> NSDate? {
        
        guard let dateString = string else { return nil }
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_GB")
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        return dateFormatter.date(from: dateString) as NSDate?
    }
}
