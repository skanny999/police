//
//  URLTests.swift
//  PoliceTests
//
//  Created by Riccardo on 27/01/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import XCTest
@testable import Police


class URLTests: XCTestCase {
    
    let managedObjectContext = CoreDataManager.shared.container.viewContext
    let location = Location(hasCoordinates: true, coordinates: ("52.629729","-1.131592"),
                            latitude: 52.629729 , longitude: -1.131592)
    let locationCoordinates = CLLocationCoordinate2D(latitude: 52.629729, longitude: -1.131592)

    override func setUp() {
        
    }
    
    func testURLsWithStandardLocation() {
        
        let urls = allURLs()
        
        for url in urls {
            let expectation = self.expectation(description: "response")
            var success = false
            NetworkProvider.getRequest(forUrl: url) { (data , error) in
                
                success = error == nil
                expectation.fulfill()
            }
            
            waitForExpectations(timeout: 5, handler: nil)
            
            XCTAssertTrue(success, "URL \(url) is invalid")
        }
    }

    override func tearDown() {

    }

    
    func allURLs() -> [URL] {
        
        let date = Date.date(fromDay: 01, month: 8, year: 2016) as NSDate
        
        Period.createPeriod(fromDate: date, isSelected: true, in: managedObjectContext)
        let period = CoreDataProvider.selectedPeriod()!
        
        return [URLFactory.dateLastUpdated(),
        URLFactory.urlForAllForces(),
        URLFactory.urlForSpecificForce(withId: "leicestershire"),
        URLFactory.urlForForceOfficers(for: "leicestershire"),
        URLFactory.urlForCrimesByExactLocationId(locationId: "884227", period: nil),
        URLFactory.urlForCrimesByExactLocationId(locationId: "884227", period: period),
        URLFactory.urlForCrimesByExactLocation(location, period: nil),
        URLFactory.urlForCrimesByExactLocation(location, period: period),
        URLFactory.urlForCrimesByMileRadious(from: location, period: nil),
        URLFactory.urlForCrimesByMileRadious(from: location, period: period),
        URLFactory.urlForOutcomesByExactLocationId(locationId: "884227", period: nil),
        URLFactory.urlForOutcomesByExactLocationId(locationId: "884227", period: period),
        URLFactory.urlForOutcomesByLocation(location: location, period: nil),
        URLFactory.urlForOutcomesByLocation(location: location, period: period),
        URLFactory.urlForSpecificOutcome(forCrime: "590d68b69228a9ff95b675bb4af591b38de561aa03129dc09a03ef34f537588c"),
        URLFactory.urlForNeighbourhood(neighbourhoodId: "NC04", policeForceId: "leicestershire", infoType: .specific),
        URLFactory.urlForNeighbourhood(neighbourhoodId: "NC04", policeForceId: "leicestershire", infoType: .boudaries),
        URLFactory.urlForNeighbourhood(neighbourhoodId: "NC04", policeForceId: "leicestershire", infoType: .team),
        URLFactory.urlForNeighbourhood(neighbourhoodId: "NC04", policeForceId: "leicestershire", infoType: .events),
        URLFactory.urlForNeighbourhood(neighbourhoodId: "NC04", policeForceId: "leicestershire", infoType: .priorities),
        URLFactory.urlToLocateNeigbourhood(from: locationCoordinates),
        URLFactory.urlForStopAndSearch(fromLocationId: "884227", period: nil),
        URLFactory.urlForStopAndSearch(fromLocationId: "884227", period: period),
        URLFactory.urlForStopAndSearchByMileRadius(fromLocation: location, period: period),
        URLFactory.urlForStopAndSearchByMileRadius(fromLocation: location, period: nil),
        URLFactory.urlForStopAnsSearchByPoliceForce(withIdentifier: "leicestershire", period: period)]
    }
    
    
    struct Location: Locatable {
        
        var hasCoordinates: Bool = false
        
        var coordinates: (lat: String, long: String)?
        
        var latitude: NSNumber?
        
        var longitude: NSNumber?
    }

}


