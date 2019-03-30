//
//  StopAndSearch+CoreDataClass.swift
//  Police
//
//  Created by Riccardo on 23/01/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//
//

import Foundation
import CoreData
import SwiftyJSON

@objc(StopAndSearch)
public class StopAndSearch: NSManagedObject, Managed {
    
    static var dataIdentifier: String = "datetime"
    static var objectIdentifier: String = "identifier"
    
    struct Key {
        static let identifier = "datetime"
        static let ageRange = "age_range"
        static let dateTime = "datetime"
        static let genderCode = "gender"
        static let legislation = "legislation"
        static let objectOfSearch = "object_of_search"
        static let officerEthnicity = "officer_defined_ethnicity"
        static let operationName = "operation_name"
        static let outCome = "outcome" 
        static let outcomeIsLinkedToSearch = "outcome_linked_to_object_of_search"
        static let outcomeObject = "outcome_object"
        static let personIsInvolved = "involved_person"
        static let stripSearch = "removal_of_more_than_outer_clothing"
        static let suspectEthnicity = "self_defined_ethnicity"
        static let typeCode = "type"
        
        static let location = "location"
        static let street = "street"
        static let name = "name"
        static let longitude = "longitude"
        static let latitude = "latitude"
    }
    
    
    static func update(_ object: StopAndSearch, with json: JSON) {
        
        object.ageRange = json[Key.ageRange].string
        object.dateTime = json[Key.dateTime].string?.dateValue
        object.genderCode = json[Key.genderCode].string
        object.legislation = json[Key.legislation].string
        object.objectOfSearch = json[Key.objectOfSearch].string
        object.officerEthnicity = json[Key.officerEthnicity].string
        object.operationName = json[Key.operationName].string
        object.outCome = json[Key.outCome].string
        object.outcomeIsLinkedToSearch = json[Key.outcomeIsLinkedToSearch].number
        object.personIsInvolved = json[Key.personIsInvolved].number
        object.stripSearch = json[Key.stripSearch].number
        object.suspectEthnicity = json[Key.suspectEthnicity].string
        object.typeCode = json[Key.typeCode].string
        object.latitude = json[Key.location][Key.latitude].string.number
        object.longitude = json[Key.location][Key.longitude].string.number
        object.streetName = json[Key.location][Key.street][Key.name].string
        object.identifier = identifier(from: json)
    }
    
    static func identifier(from json: JSON) -> String {
        
        return "\(json[Key.dateTime].string!)\(json[Key.location][Key.latitude].string!)\(json[Key.location][Key.longitude].string!)"
    }
    
    static func managedObject(withJson json: JSON, in context: NSManagedObjectContext) {

        if let object = StopAndSearch.object(withId: identifier(from: json)) {
            
            update(object, with: json)
            
        } else {
            
            let object = StopAndSearch(entity: self.entity(), insertInto: context)
            
            update(object, with: json)
        }
    }
    
    static func object(withId id: String) -> StopAndSearch? {
        
        return try! CoreDataManager.shared.container.viewContext.fetch(fetchRequest(forId: id)).first as? StopAndSearch
    }
    
    private static func fetchRequest(forId id: String) -> NSFetchRequest<NSFetchRequestResult> {
        
        let request = self.sortedFetchRequest
        
        request.predicate = NSPredicate(format: "%K == %@", objectIdentifier, id)
        return request as! NSFetchRequest<NSFetchRequestResult>
    }
    
}
