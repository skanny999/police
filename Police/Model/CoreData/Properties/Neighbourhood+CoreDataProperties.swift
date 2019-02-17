//
//  Neighbourhood+CoreDataProperties.swift
//  Police
//
//  Created by Riccardo on 23/01/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//
//

import Foundation
import CoreData


extension Neighbourhood {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Neighbourhood> {
        return NSFetchRequest<Neighbourhood>(entityName: "Neighbourhood")
    }

    @NSManaged public var identifier: String?
    @NSManaged public var longDescription: String?
    @NSManaged public var name: String?
    @NSManaged public var population: String?
    @NSManaged public var latitude: String?
    @NSManaged public var longitude: String?
    @NSManaged public var contact: Contact?
    @NSManaged public var events: Set<Event>?
    @NSManaged public var officers: Set<Officer>?
    @NSManaged public var places: Set<Place>?
    @NSManaged public var priorities: Set<Priority>?

}

// MARK: Generated accessors for events
extension Neighbourhood {

    @objc(addEventsObject:)
    @NSManaged public func addToEvents(_ value: Event)

    @objc(removeEventsObject:)
    @NSManaged public func removeFromEvents(_ value: Event)

    @objc(addEvents:)
    @NSManaged public func addToEvents(_ values: Set<Event>)

    @objc(removeEvents:)
    @NSManaged public func removeFromEvents(_ values: Set<Event>)

}

// MARK: Generated accessors for officers
extension Neighbourhood {

    @objc(addOfficersObject:)
    @NSManaged public func addToOfficers(_ value: Officer)

    @objc(removeOfficersObject:)
    @NSManaged public func removeFromOfficers(_ value: Officer)

    @objc(addOfficers:)
    @NSManaged public func addToOfficers(_ values: Set<Officer>)

    @objc(removeOfficers:)
    @NSManaged public func removeFromOfficers(_ values: Set<Officer>)

}

// MARK: Generated accessors for places
extension Neighbourhood {

    @objc(addPlacesObject:)
    @NSManaged public func addToPlaces(_ value: Place)

    @objc(removePlacesObject:)
    @NSManaged public func removeFromPlaces(_ value: Place)

    @objc(addPlaces:)
    @NSManaged public func addToPlaces(_ values: Set<Place>)

    @objc(removePlaces:)
    @NSManaged public func removeFromPlaces(_ values: Set<Place>)

}

// MARK: Generated accessors for priorities
extension Neighbourhood {

    @objc(addPrioritiesObject:)
    @NSManaged public func addToPriorities(_ value: Priority)

    @objc(removePrioritiesObject:)
    @NSManaged public func removeFromPriorities(_ value: Priority)

    @objc(addPriorities:)
    @NSManaged public func addToPriorities(_ values: Set<Priority>)

    @objc(removePriorities:)
    @NSManaged public func removeFromPriorities(_ values: Set<Priority>)

}
