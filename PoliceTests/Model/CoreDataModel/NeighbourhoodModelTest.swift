//
//  NeighbourhoodModelTest.swift
//  PoliceTests
//
//  Created by Riccardo on 17/04/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import XCTest

import XCTest
import CoreData
import SwiftyJSON
@testable import Police

class NeighbourhoodModelTest: XCTestCase {
    
    var mockContainer: NSPersistentContainer?
    
    override func setUp() {
        
        if mockContainer == nil {
            mockContainer = CoreDataManager.shared.container
        }
    }
    
    override func tearDown() {
        
        mockContainer = nil
    }
    
    func testNeighbourhoodObject() {
        
        let dataArray = [dataFromFile(JSONFile.Neighbourhood.specificNeighbourhood),
                         dataFromFile(JSONFile.Boudaries.neighbourhoodBoundaries),
                         dataFromFile(JSONFile.Officers.officers),
                         dataFromFile(JSONFile.Events.events),
                         dataFromFile(JSONFile.Priorities.priorities)]
        
        
        let longDescription = "<p>The Castle neighbourhood is a diverse covering all of the City Centre. In addition it covers De Montfort University, the University of Leicester, Leicester Royal Infirmary, the Leicester Tigers rugby ground and the Clarendon Park and Riverside communities.</p>\n<p>The Highcross and Haymarket shopping centres and Leicester's famous Market are all covered by this neighbourhood.</p>"
        
        // Original data
        let data = dataFromFile(JSONFile.Neighbourhood.specificNeighbourhood)
        
        UpdateProcessor.updateNeighbourhood(withDataArray: dataArray, identifier: "NC04") { [weak self] (updated, neighbourood)  in
            
            let neighbourhood = self?.savedObject(ofType: Neighbourhood.self, withData: dataArray[0])
            XCTAssertTrue(neighbourhood?.identifier == "NC04", neighbourhood?.identifier ?? "nil")
            XCTAssertTrue(neighbourhood?.longDescription == longDescription, neighbourhood?.longDescription ?? "nil")
            XCTAssertTrue(neighbourhood?.name == "City Centre",neighbourhood?.name ?? "nil")
            XCTAssertTrue(neighbourhood?.population == "0",neighbourhood?.population ?? "nil")
            XCTAssertTrue(neighbourhood?.latitude == 52.6389)
            XCTAssertTrue(neighbourhood?.longitude == -1.13619)
            //Contact
            XCTAssertTrue(neighbourhood?.contact?.email == "centralleicester.npa@leicestershire.pnn.police.uk", neighbourhood?.contact?.email ?? "nil")
            XCTAssertTrue(neighbourhood?.contact?.telephone == "101", neighbourhood?.contact?.telephone ?? "nil")
            XCTAssertTrue(neighbourhood?.contact?.facebook == "http://www.facebook.com/leicspolice", neighbourhood?.contact?.facebook ?? "nil")
            XCTAssertTrue(neighbourhood?.contact?.twitter == "http://www.twitter.com/centralleicsNPA", neighbourhood?.contact?.twitter ?? "nil")
            XCTAssertTrue(neighbourhood?.contact?.forceUrl == "http://www.leics.police.uk/local-policing/city-centre", neighbourhood?.contact?.forceUrl ?? "nil")
            XCTAssertTrue(neighbourhood?.contact?.website == "http://www.leicester.gov.uk/", neighbourhood?.contact?.website ?? "nil")
            //Locations
            XCTAssertTrue(neighbourhood?.places?.first?.name == "Mansfield House", neighbourhood?.places?.first?.name ?? "nil")
            XCTAssertTrue(neighbourhood?.places?.first?.postcode == "LE1 3GG", neighbourhood?.places?.first?.postcode ?? "nil")
            XCTAssertTrue(neighbourhood?.places?.first?.address == "74 Belgrave Gate\n, Leicester", neighbourhood?.places?.first?.address ?? "nil")
            XCTAssertTrue(neighbourhood?.places?.first?.typeCode == "station", neighbourhood?.places?.first?.typeCode ?? "nil")
            XCTAssertTrue(neighbourhood?.places?.first?.longDescription == nil, neighbourhood?.places?.first?.longDescription ?? "nil")
            XCTAssertTrue(neighbourhood?.places?.first?.latitude == nil)
            XCTAssertTrue(neighbourhood?.places?.first?.longitude == nil)
            
            //Boundaries
            
            if let boundarieData = neighbourhood?.polygonData,
                let polygon = boundarieData.polygon {
                
                let coordsPointer = UnsafeMutablePointer<CLLocationCoordinate2D>.allocate(capacity: polygon.pointCount)
                polygon.getCoordinates(coordsPointer, range: NSMakeRange(0, polygon.pointCount))
                var points: [(lat: Double, lon: Double)] = []
                for i in 0..<polygon.pointCount {
                    points.append((coordsPointer[i].latitude, coordsPointer[i].longitude))
                }
                
                XCTAssertTrue(points.count == 4, "\(points.count)")
                XCTAssertTrue(points[0].lat.short == 52.639405, "\(points[0].lat)")
                XCTAssertTrue(points[0].lon.short == -1.145862, "\(points[0].lon)")
                XCTAssertTrue(points[1].lat.short == 52.638945, "\(points[1].lat)")
                XCTAssertTrue(points[1].lon.short == -1.145706, "\(points[1].lon)")
                XCTAssertTrue(points[2].lat.short == 52.638371, "\(points[2].lat)")
                XCTAssertTrue(points[2].lon.short == -1.145576, "\(points[2].lon)")
                XCTAssertTrue(points[3].lat.short == 52.637738, "\(points[3].lat)")
                XCTAssertTrue(points[3].lon.short == -1.145376, "\(points[3].lon)")
                
            } else {
                XCTFail("no polygon")
            }
            
            
            //Officers
            
            XCTAssertTrue(neighbourhood?.officers?.count == 12, "\(neighbourhood?.officers?.count ?? 0)")
            let officers = neighbourhood?.officers?.sorted { $0.name! < $1.name! }
            
            let firstOfficerBio = "I started as a police community support officer in 2006; I have spent this time working in the city centre which I thoroughly enjoy.\nI am looking forward to the new challenges that come along.\nPlease feel free to speak to me about any issues, or even for just a social chat.\n"
            
            XCTAssertTrue(officers?.first?.name == "Alice Forfar")
            XCTAssertTrue(officers?.first?.rank == "Sgt")
            XCTAssertTrue(officers?.first?.bio == firstOfficerBio, officers?.first?.bio ?? "No bio")
            XCTAssertTrue(officers?.first?.contact?.isEmpty ?? false)
            XCTAssertTrue(officers?.last?.name == "Tim Jones")
            XCTAssertTrue(officers?.last?.rank == "PCSO")
            XCTAssertTrue(officers?.last?.bio == nil)
            XCTAssertTrue(officers?.last?.contact?.isEmpty ?? false)
            
            //Events
            let events = neighbourhood?.events?.sorted { $0.title! > $1.title! }
            
            XCTAssertTrue(events?.first?.title == "Crime Prevention Sale, Merlin Heights", events?.first?.title ?? "nil")
            XCTAssertTrue(events?.first?.longDescription == "Crime Prevention Sale\n", events?.first?.longDescription ?? "nil")
            XCTAssertTrue(events?.first?.address == "Merlin Heights Reception, Bath lane", events?.first?.address ?? "nil")
            XCTAssertTrue(events?.first?.typeCode == "meeting", events?.first?.typeCode ?? "nil")
            
            if let startDate = events?.first?.startDate, let endDate = events?.first?.endDate {
                
                XCTAssertTrue(startDate.component.month == 2)
                XCTAssertTrue(startDate.component.day == 18)
                XCTAssertTrue(startDate.component.hour == 9)
                XCTAssertTrue(endDate.component.month == 2)
                XCTAssertTrue(endDate.component.day == 18)
                XCTAssertTrue(endDate.component.hour == 10)
            } else {
                XCTFail("Event date is nil")
            }
            
            XCTAssertTrue(events?.last?.title == "Community Engagement, Guru Nanak Gurdwara", events?.last?.title ?? "nil")
            XCTAssertTrue(events?.last?.longDescription == nil, events?.last?.longDescription ?? "nil")
            XCTAssertTrue(events?.last?.address == "Guru Nanak Gurdwara,", events?.last?.address ?? "nil")
            XCTAssertTrue(events?.last?.typeCode == "meeting", events?.last?.typeCode ?? "nil")
            
            if let startDate = events?.last?.startDate, let endDate = events?.last?.endDate {
                
                XCTAssertTrue(startDate.component.month == 2)
                XCTAssertTrue(startDate.component.day == 19)
                XCTAssertTrue(startDate.component.hour == 11)
                XCTAssertTrue(endDate.component.month == 2)
                XCTAssertTrue(endDate.component.day == 19)
                XCTAssertTrue(endDate.component.hour == 12)
            } else {
                XCTFail("Event date is nil")
            }
            
            //Priorities
            
            XCTAssert(neighbourhood?.priorities?.count == 60)
            
            let priorities = neighbourhood?.priorities?.sorted { $0.issueDate!.compare($1.issueDate! as Date) == ComparisonResult.orderedDescending }
            XCTAssert(priorities?.first?.issueDate?.component.day == 1)
            XCTAssert(priorities?.first?.issueDate?.component.month == 2)
            XCTAssert(priorities?.first?.issueDate?.component.year == 2019, "\(String(describing: priorities?.first?.issueDate?.component.year))")
            XCTAssert(priorities?.first?.issue == "Robberies Once again we have growing concerns about the number of robberies we’ve seen in the City over the last month and have therefore made it a priority for us again this month. We have seen a number of cases reported where groups of suspects appear to work together to target lone males.\n")
            XCTAssert(priorities?.first?.actionDate?.component.day == nil)
            XCTAssert(priorities?.first?.actionDate?.component.day == nil)
            XCTAssert(priorities?.first?.actionDate?.component.day == nil)
            XCTAssert(priorities?.first?.action == nil)
            
            
        }
        
        
        // Edited data
        let editedDataArray = [dataFromFile(JSONFile.Neighbourhood.neighbourhoodEdited),
                               Data(), // add coordinates file for polygon to test
            dataFromFile(JSONFile.Officers.officers),
            dataFromFile(JSONFile.Events.events),
            dataFromFile(JSONFile.Priorities.priorities)]
        
        UpdateProcessor.updateNeighbourhood(withDataArray: editedDataArray, identifier: "NC04") { [weak self] (updated, neighbourhood) in
            
            let neighbourhood = self?.savedObject(ofType: Neighbourhood.self, withData: data)
            XCTAssertTrue(neighbourhood?.identifier == "NC04", neighbourhood?.identifier ?? "nil")
            XCTAssertTrue(neighbourhood?.longDescription == longDescription, neighbourhood?.longDescription ?? "nil")
            XCTAssertTrue(neighbourhood?.name == "City Centre",neighbourhood?.name ?? "nil")
            XCTAssertTrue(neighbourhood?.population == "0",neighbourhood?.population ?? "nil")
            XCTAssertTrue(neighbourhood?.latitude == 52.6389, neighbourhood?.latitude?.stringValue ?? "nil")
            XCTAssertTrue(neighbourhood?.longitude == -1.13619, neighbourhood?.longitude?.stringValue ?? "nil")
            //Contact
            XCTAssertTrue(neighbourhood?.contact?.email == "centralleicester.npa@leicestershire.pnn.police.uk", neighbourhood?.contact?.email ?? "nil")
            XCTAssertTrue(neighbourhood?.contact?.telephone == "010", neighbourhood?.contact?.telephone ?? "nil")
            XCTAssertTrue(neighbourhood?.contact?.facebook == "http://www.facebook.com/leicspolice", neighbourhood?.contact?.facebook ?? "nil")
            XCTAssertTrue(neighbourhood?.contact?.twitter == "http://www.twitter.com/centralleicsNPA", neighbourhood?.contact?.twitter ?? "nil")
            XCTAssertTrue(neighbourhood?.contact?.forceUrl == "http://www.leics.police.uk/local-policing", neighbourhood?.contact?.forceUrl ?? "nil")
            XCTAssertTrue(neighbourhood?.contact?.website == "http://www.leicester.gov", neighbourhood?.contact?.website ?? "nil")
            
            //Locations
            let locations = neighbourhood?.places?.sorted { $0.name! < $1.name! }
            XCTAssertTrue(locations?.first?.name == "Mansfield House", locations?.first?.name ?? "nil")
            XCTAssertTrue(locations?.first?.postcode == "LE1 3GG", locations?.first?.postcode ?? "nil")
            XCTAssertTrue(locations?.first?.address == "74 Belgrave Gate\n, Leicester", locations?.first?.address ?? "nil")
            XCTAssertTrue(locations?.first?.typeCode == "station", locations?.first?.typeCode ?? "nil")
            XCTAssertTrue(locations?.first?.longDescription == nil, locations?.first?.longDescription ?? "nil")
            XCTAssertTrue(locations?.first?.latitude == nil, locations?.first?.latitude?.stringValue ?? "nil")
            XCTAssertTrue(locations?.first?.longitude == nil, locations?.first?.longitude?.stringValue ?? "nil")
            XCTAssertTrue(locations?.last?.name == "Random House", locations?.last?.name ?? "nil")
            XCTAssertTrue(locations?.last?.postcode == "LE1 3GG", locations?.last?.postcode ?? "nil")
            XCTAssertTrue(locations?.last?.address == "74 Belgrave Gate\n, Leicester", locations?.last?.address ?? "nil")
            XCTAssertTrue(locations?.last?.typeCode == "station", locations?.last?.typeCode ?? "nil")
            XCTAssertTrue(locations?.last?.longDescription == "It's a random house", locations?.last?.longDescription ?? "nil")
            XCTAssertTrue(locations?.last?.latitude == -1.0967, locations?.last?.latitude?.stringValue ?? "nil")
            XCTAssertTrue(locations?.last?.longitude == 53.214, locations?.last?.longitude?.stringValue ?? "nil")
            
            //Officers
            
            XCTAssertTrue(neighbourhood?.officers?.count == 12, "\(neighbourhood?.officers?.count ?? 0)")
            let officers = neighbourhood?.officers?.sorted { $0.name! < $1.name! }
            
            let firstOfficerBio = "I started as a police community support officer in 2006; I have spent this time working in the city centre which I thoroughly enjoy.\nI am looking forward to the new challenges that come along.\nPlease feel free to speak to me about any issues, or even for just a social chat.\n"
            
            XCTAssertTrue(officers?.first?.name == "Alice Forfar")
            XCTAssertTrue(officers?.first?.rank == "Sgt")
            XCTAssertTrue(officers?.first?.bio == firstOfficerBio, officers?.first?.bio ?? "No bio")
            XCTAssertTrue(officers?.first?.contact?.isEmpty ?? false)
            XCTAssertTrue(officers?.last?.name == "Tim Jones")
            XCTAssertTrue(officers?.last?.rank == "PCSO")
            XCTAssertTrue(officers?.last?.bio == nil)
            XCTAssertTrue(officers?.last?.contact?.isEmpty ?? false)
            
            //Events
            let events = neighbourhood?.events?.sorted { $0.title! > $1.title! }
            
            XCTAssertTrue(events?.first?.title == "Crime Prevention Sale, Merlin Heights", events?.first?.title ?? "nil")
            XCTAssertTrue(events?.first?.longDescription == "Crime Prevention Sale\n", events?.first?.longDescription ?? "nil")
            XCTAssertTrue(events?.first?.address == "Merlin Heights Reception, Bath lane", events?.first?.address ?? "nil")
            XCTAssertTrue(events?.first?.typeCode == "meeting", events?.first?.typeCode ?? "nil")
            
            if let startDate = events?.first?.startDate, let endDate = events?.first?.endDate {
                
                XCTAssertTrue(startDate.component.month == 2)
                XCTAssertTrue(startDate.component.day == 18)
                XCTAssertTrue(startDate.component.hour == 9)
                XCTAssertTrue(endDate.component.month == 2)
                XCTAssertTrue(endDate.component.day == 18)
                XCTAssertTrue(endDate.component.hour == 10)
            } else {
                XCTFail("Event date is nil")
            }
            
            XCTAssertTrue(events?.last?.title == "Community Engagement, Guru Nanak Gurdwara", events?.last?.title ?? "nil")
            XCTAssertTrue(events?.last?.longDescription == nil, events?.last?.longDescription ?? "nil")
            XCTAssertTrue(events?.last?.address == "Guru Nanak Gurdwara,", events?.last?.address ?? "nil")
            XCTAssertTrue(events?.last?.typeCode == "meeting", events?.last?.typeCode ?? "nil")
            
            if let startDate = events?.last?.startDate, let endDate = events?.last?.endDate {
                
                XCTAssertTrue(startDate.component.month == 2)
                XCTAssertTrue(startDate.component.day == 19)
                XCTAssertTrue(startDate.component.hour == 11)
                XCTAssertTrue(endDate.component.month == 2)
                XCTAssertTrue(endDate.component.day == 19)
                XCTAssertTrue(endDate.component.hour == 12)
            } else {
                XCTFail("Event date is nil")
            }
            
            //Priorities
            
            XCTAssert(neighbourhood?.priorities?.count == 60)
            
            let priorities = neighbourhood?.priorities?.sorted { $0.issueDate!.compare($1.issueDate! as Date) == ComparisonResult.orderedDescending }
            XCTAssert(priorities?.first?.issueDate?.component.day == 1)
            XCTAssert(priorities?.first?.issueDate?.component.month == 2)
            XCTAssert(priorities?.first?.issueDate?.component.year == 2019, "\(String(describing: priorities?.first?.issueDate?.component.year))")
            XCTAssert(priorities?.first?.issue == "Robberies Once again we have growing concerns about the number of robberies we’ve seen in the City over the last month and have therefore made it a priority for us again this month. We have seen a number of cases reported where groups of suspects appear to work together to target lone males.\n")
            XCTAssert(priorities?.first?.actionDate?.component.day == nil)
            XCTAssert(priorities?.first?.actionDate?.component.day == nil)
            XCTAssert(priorities?.first?.actionDate?.component.day == nil)
            XCTAssert(priorities?.first?.action == nil)
        }
    }
    
    
    // MARK: - Generic helpers
    
    func updateObject<T: Updatable>(type: T.Type, withData data: Data, completion: @escaping () -> Void) {
        
        let expectation = self.expectation(description: T.entityName)
        
        UpdateProcessor.updateObject(ofType: T.self, fromData: data) { (completed) in
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 3, handler: nil)
        completion()
    }
    
    
    func savedObject<T: Updatable>(ofType objectClass: T.Type, withData data: Data) -> T where T: NSManagedObject {
        
        if let json = try? JSON(data: data),
            let objectId = json[objectClass.dataIdentifier].number?.stringValue ?? json[objectClass.dataIdentifier].string,
            let object = objectClass.object(withId: objectId, in: CoreDataManager.shared.container.viewContext) {
            
            return object
        }
        fatalError("Couldn't parse neighbourhood")
    }
    
    func dataFromFile(_ fileName: String) -> Data {
        
        return FileExtractor.extractJsonFile(withName: fileName, forClass: type(of: self))
    }
}
