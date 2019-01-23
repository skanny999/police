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

@objc(StopAndSearch)
public class StopAndSearch: NSManagedObject {
    
    struct Key {
        let ageRange = "age_range"
        let dateTime = "datetime"
        let genderCode = "gender"
        let legislation = "legislation"
        let locationId = "" //street id
        let objectOfSearch = "object_of_search"
        let officerEthnicity = "officer_defined_ethnicity"
        let operationName = "operation_name"
        let outCome = "outcome"
        let outcomeIsLinkedToSearch = "outcome_linked_to_object_of_search"
        let outcomeObject = "" //not needed
        let personIsInvolved = "involved_person"
        let streetName = "" //street id
        let stripSearch = "removal_of_more_than_outer_clothing"
        let suspectEthnicity = "self_defined_ethnicity"
        let typeCode = "type"
    }

}
