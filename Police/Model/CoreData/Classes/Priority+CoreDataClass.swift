//
//  Priority+CoreDataClass.swift
//  Police
//
//  Created by Riccardo on 23/01/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//
//

import Foundation
import CoreData
import SwiftyJSON

@objc(Priority)
public class Priority: NSManagedObject {

    struct Key {
        static let issue = "issue"
        static let issueDate = "issue-date"
        static let action = "action"
        static let actionDate = "action-date"
    }
    
    class func createPriority(from json: JSON, in context: NSManagedObjectContext?) -> Priority {

        let priority = Priority(entity: self.entity(), insertInto: context)
        priority.update(from: json)
        return priority
    }
    
    private func update(from json: JSON) {
        
        self.issue = json[Key.issue].string?.stripOutHtml()
        self.issueDate = json[Key.issueDate].string?.dateValue
        self.action = json[Key.action].string?.stripOutHtml()
        self.actionDate = json[Key.actionDate].string?.dateValue
    }
    
}
