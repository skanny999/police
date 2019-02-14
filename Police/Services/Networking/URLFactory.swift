//
//  URLFactory.swift
//  Police
//
//  Created by Riccardo on 26/01/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//



import Foundation

struct URLFactory {
    
    private static let baseUrl = "https://data.police.uk/api/"
    private static let lastUpdated = "crime-last-updated"
    
    // Last updated
    
    static func dateLastUpdated() -> URL {
        
        return completeUrl(with: lastUpdated)
    }
    
    // Forces

    static func urlForAllForces() -> URL {
        
        return completeUrl(with: Forces.list.rawValue)
    }
    
    static func urlForSpecificForce(withId forceId: String) -> URL {
        
        let endPoint = String(format: Forces.specificForce.rawValue, forceId)
        return completeUrl(with: endPoint)
    }
    
    static func urlForForceOfficers(for forceId: String) -> URL {
        
        let endPoint = String(format: Forces.officers.rawValue, forceId)
        return completeUrl(with: endPoint)
    }
    
    //Crimes
    
    static func urlForCrimesByExactLocationId(locationId: String, period: Period?) -> URL {
        
        let endPoint = String(format: Crimes.byExactLocationId.rawValue, dateString(for: period), locationId)
        return completeUrl(with: endPoint)
    }
    
    static func urlForCrimesByExactLocation(_ location: Locatable, period: Period?) -> URL {
        
        let endpoint = String(format: Crimes.byExactLocation.rawValue, dateString(for: period), location.latitude!, location.longitude!)
        return completeUrl(with: endpoint)
    }
    
    static func urlForCrimesByMileRadious(from location: Locatable, period: Period?) -> URL {
        
        let endpoint = String(format: Crimes.byLocationRadius.rawValue, location.latitude!, location.longitude!, dateString(for: period))
        return completeUrl(with: endpoint)
    }
    
    
    private static func urlForCrimesByArea() {
        
        // Create area object with array of locations
    }
    
    
    //Outcomes
    
    static func urlForOutcomesByExactLocationId(locationId: String, period: Period?) -> URL {
        
        let endPoint = String(format: Outcomes.byLocationId.rawValue, dateString(for: period), locationId)
        return completeUrl(with: endPoint)
    }
    
    static func urlForOutcomesByLocation(location: Locatable, period: Period?) -> URL {
        
        if !location.hasCoordinates {
            fatalError("Location must have coordinates")
        }
        
        let endpoint = String(format: Outcomes.byLocation.rawValue, dateString(for: period), location.coordinates!.lat, location.coordinates!.long)
        return completeUrl(with: endpoint)
    }
    
    static func urlForSpecificOutcome(forCrime crimeId: String) -> URL {
        
        let endpoint = String(format: Outcomes.specificOutcome.rawValue, crimeId)
        return completeUrl(with:endpoint)
    }
    
    private static func urlForOutcomesByArea() {
        
        // Create area object with array of locations
        
    }
    
    // Neighbourood
    
    static func urlForNeighbourhood(neighbourhoodId: String, policeForceId: String, infoType: NeighborhoodInfoType) -> URL {
        
        let endpoint = String(format: "%@/%@%@", policeForceId, neighbourhoodId, infoType.rawValue)
        return completeUrl(with: endpoint)
    }
    
    static func urlToLocateNeigbourhood(from location: Locatable) -> URL {
        
        if !location.hasCoordinates {
            fatalError("Location must have coordinates")
        }
        
        let endpoint = String(format: "locate-neighbourhood?q=%@,%@", location.coordinates!.lat, location.coordinates!.long)
        return completeUrl(with: endpoint)
    }
    
    
    //Stop and search
    
    static func urlForStopAndSearch(fromLocationId locationId: String, period: Period?) -> URL {
        
        let endpoint = String(format: StopSearch.byExactLocationId.rawValue, locationId, dateString(for: period))
        
        
        return completeUrl(with: endpoint)
    }
    
    static func urlForStopAndSearchByMileRadius(fromLocation location: Locatable, period: Period?) -> URL {
        
        if !location.hasCoordinates {
            fatalError("Location must have coordinates")
        }
        
        let endpoint = String(format: StopSearch.byLocationRadius.rawValue, location.coordinates!.lat, location.coordinates!.long, dateString(for: period))
        return completeUrl(with: endpoint)
    }
    
    static func urlForStopAnsSearchByPoliceForce(withIdentifier forceId: String, period: Period?) -> URL {
        
        let endpoint = String(format: StopSearch.byForceNoLocation.rawValue, forceId, dateString(for: period))
        return completeUrl(with:endpoint)
    }
    
}

enum NeighborhoodInfoType: String {
    case specific = "" //force, neighbourhoodId
    case boudaries = "/boundary" //as above
    case team = "/people" //as above
    case events = "/events" //as above
    case priorities = "/priorities" //as above
}


private extension URLFactory {
    
    private static func completeUrl(with endpoint: String) -> URL {
        
        return URL(string:"\(self.baseUrl)\(endpoint)")!
    }
    
    private static func dateString(for period: Period?) -> String {
        
        guard let period = period else { return "" }
        return String(format: Crimes.addDate.rawValue, period.year, period.month)
    }
}

private enum Forces: String {
    case list = "forces"
    case specificForce = "forces/%@" //force name
    case officers = "forces/%@/people" // forceName
}

private enum Crimes: String {
    case byExactLocationId = "crimes-at-location?%@location_id=%@" //crimes-at-location?date=2017-02&location_id=884227
    case byExactLocation = "crimes-at-location?%@lat=%@&lng=%@" // crimes-at-location?date=2017-02&lat=52.629729&lng=-1.131592outcome
    case byLocationRadius = "crimes-street/all-crime?lat=%@&lng=%@%@" //crimes-street/all-crime?lat=52.629729&lng=-1.131592&date=2017-01
    case byArea = "crimes-street/all-crime?poly=%@%@" //lat,long:lat,long:...
    case addDate = "&date=%@-%@&" //year,month
}

private enum Outcomes: String {
    case byLocationId = "outcomes-at-location?%@location_id=%@" //outcomes-at-location?date=2017-01&location_id=883498
    case byLocation = "outcomes-at-location?%@lat=%@&lng=%@" // outcomes-at-location?date=2017-01&lat=52.629729&lng=-1.131592
    case byArea = "outcomes-at-location?%@poly=%@" //date as above, lat,long:lat,long:...
    case specificOutcome = "outcomes-for-crime/%@" // outcomes-for-crime/590d68b69228a9ff95b675bb4af591b38de561aa03129dc09a03ef34f537588c
}


private enum StopSearch: String {
    case byExactLocationId = "stops-at-location?location_id=%@%@" //api/stops-at-location?location_id=883407&date=2017-01
    case byForceNoLocation = "stops-no-location?force=%@%@" // police force
    case byLocationRadius = "stops-street?lat=%@&lng=%@%@" //stops-street?lat=52.629729&lng=-1.131592&date=2018-06
    case byArea = "stops-street?poly=%@" //lat,long:lat,long:...
    case addDate = "&date=%@-%@" //year,month
}

