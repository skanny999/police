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

@objc(Priority)
public class Priority: NSManagedObject {

    struct Key {
        let action = "action"
        let issue = "issue"
        let issueDate = "issue-date"
        let actionDate = "action-date"
    }
}
