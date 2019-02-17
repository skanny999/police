//
//  CoreDataModelTest.swift
//  PoliceTests
//
//  Created by Riccardo on 03/02/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import XCTest
import CoreData
import SwiftyJSON
@testable import Police

class CoreDataModelTest: XCTestCase {
    
    var mockContainer: NSPersistentContainer?

    override func setUp() {
        
        if mockContainer == nil {
           mockContainer = CoreDataManager.shared().container
        }
    }

    override func tearDown() {
        
        mockContainer = nil
    }
    
    // MARK: - Crime
    
    func testCrimeObject() {
        
       var data = FileExtractor.extractJsonFile(withName: JSONFile.Crimes.crime, forClass: type(of: self))
        
        updateObject(type: Crime.self, withData: data) { [weak self] in
            
            let crime = self?.savedObject(ofType: Crime.self, withData: data)
            XCTAssertTrue(crime?.locationTypeCode == "Force")
            XCTAssertTrue(crime?.category == .antiSocialBehaviour)
            XCTAssertTrue(crime?.extraContent == "")
            XCTAssertTrue(crime?.identifier == "54164419")
            XCTAssertTrue(crime?.locationId == 0)
            XCTAssertTrue(crime?.locationSubtypeCode == "")
            XCTAssertTrue(crime?.month == "01")
            XCTAssertTrue(crime?.persistentId == "fsdfskdjfslkdjfsldkfsdlskd")
            XCTAssertTrue(crime?.streetName == "On or near Wharf Street North")
            XCTAssertTrue(crime?.year == "2017")
            XCTAssertTrue(crime?.latitude == "52.640961")
            XCTAssertTrue(crime?.longitude == "-1.126371")
            XCTAssertTrue(crime?.outcomes?.first?.category == .underInvestigation)
            XCTAssertTrue(crime?.outcomes?.first?.date == "2017-05")
            XCTAssertTrue(crime?.outcomes?.first?.personId == nil)
        }
        
        data = FileExtractor.extractJsonFile(withName: JSONFile.Crimes.crimeEdited, forClass: type(of: self))
        
        updateObject(type: Crime.self, withData: data) { [weak self] in
            
            let crime = self?.savedObject(ofType: Crime.self, withData: data)
            XCTAssertTrue(crime?.locationTypeCode == "Travel")
            XCTAssertTrue(crime?.category == .antiSocialBehaviour)
            XCTAssertTrue(crime?.extraContent == "")
            XCTAssertTrue(crime?.identifier == "54164419")
            XCTAssertTrue(crime?.locationId == 0)
            XCTAssertTrue(crime?.locationSubtypeCode == "")
            XCTAssertTrue(crime?.month == "01")
            XCTAssertTrue(crime?.persistentId == "fsdfskdjfslkdjfsldkfsdlskd")
            XCTAssertTrue(crime?.streetName == "On or near Wharf Street North")
            XCTAssertTrue(crime?.year == "2017")
            XCTAssertTrue(crime?.latitude == "52.640961")
            XCTAssertTrue(crime?.longitude == "-1.126371")
            
            let outcomes = crime?.outcomes?.sorted {$0.date! < $1.date!}

            XCTAssertTrue(outcomes?.first?.category == .underInvestigation)
            XCTAssertTrue(outcomes?.first?.date == "2017-05")
            XCTAssertTrue(outcomes?.first?.personId == nil)
            XCTAssertTrue(outcomes?.last?.category == .formalActionNotInPublicInterest)
            XCTAssertTrue(outcomes?.last?.date == "2017-06")
            XCTAssertTrue(outcomes?.last?.personId == nil)
            
        }
    }

    // MARK: - Neighbourhood
    
    func testNeighbourhoodObject() {
        
        let longDescription = "<p>The Castle neighbourhood is a diverse covering all of the City Centre. In addition it covers De Montfort University, the University of Leicester, Leicester Royal Infirmary, the Leicester Tigers rugby ground and the Clarendon Park and Riverside communities.</p>\n<p>The Highcross and Haymarket shopping centres and Leicester's famous Market are all covered by this neighbourhood.</p>"
        
        // Original data
        let data = FileExtractor.extractJsonFile(withName: JSONFile.Neighbourhood.specificNeighbourhood, forClass: type(of: self))
        
        updateObject(type: Neighbourhood.self, withData: data) { [weak self] in
            
            let neighbourhood = self?.savedObject(ofType: Neighbourhood.self, withData: data)
            XCTAssertTrue(neighbourhood?.identifier == "NC04", neighbourhood?.identifier ?? "nil")
            XCTAssertTrue(neighbourhood?.longDescription == longDescription, neighbourhood?.longDescription ?? "nil")
            XCTAssertTrue(neighbourhood?.name == "City Centre",neighbourhood?.name ?? "nil")
            XCTAssertTrue(neighbourhood?.population == "0",neighbourhood?.population ?? "nil")
            XCTAssertTrue(neighbourhood?.coordinates?.lat == "52.6389", neighbourhood?.coordinates?.lat ?? "nil")
            XCTAssertTrue(neighbourhood?.coordinates?.long == "-1.13619", neighbourhood?.coordinates?.long ?? "nil")
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
            XCTAssertTrue(neighbourhood?.places?.first?.coordinates?.lat == nil, neighbourhood?.places?.first?.coordinates?.lat ?? "nil")
            XCTAssertTrue(neighbourhood?.places?.first?.coordinates?.long == nil, neighbourhood?.places?.first?.coordinates?.long ?? "nil")
        }
        
        // Edited data
        let editedData = FileExtractor.extractJsonFile(withName: JSONFile.Neighbourhood.neighbourhoodEdited, forClass: type(of: self))
        
        updateObject(type: Neighbourhood.self, withData: editedData) { [weak self] in
            
            let neighbourhood = self?.savedObject(ofType: Neighbourhood.self, withData: data)
            XCTAssertTrue(neighbourhood?.identifier == "NC04", neighbourhood?.identifier ?? "nil")
            XCTAssertTrue(neighbourhood?.longDescription == longDescription, neighbourhood?.longDescription ?? "nil")
            XCTAssertTrue(neighbourhood?.name == "City Centre",neighbourhood?.name ?? "nil")
            XCTAssertTrue(neighbourhood?.population == "0",neighbourhood?.population ?? "nil")
            XCTAssertTrue(neighbourhood?.coordinates?.lat == "52.6389", neighbourhood?.coordinates?.lat ?? "nil")
            XCTAssertTrue(neighbourhood?.coordinates?.long == "-1.13619", neighbourhood?.coordinates?.long ?? "nil")
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
            XCTAssertTrue(locations?.first?.coordinates?.lat == nil, locations?.first?.coordinates?.lat ?? "nil")
            XCTAssertTrue(locations?.first?.coordinates?.long == nil, locations?.first?.coordinates?.long ?? "nil")
            XCTAssertTrue(locations?.last?.name == "Random House", locations?.last?.name ?? "nil")
            XCTAssertTrue(locations?.last?.postcode == "LE1 3GG", locations?.last?.postcode ?? "nil")
            XCTAssertTrue(locations?.last?.address == "74 Belgrave Gate\n, Leicester", locations?.last?.address ?? "nil")
            XCTAssertTrue(locations?.last?.typeCode == "station", locations?.last?.typeCode ?? "nil")
            XCTAssertTrue(locations?.last?.longDescription == "It's a random house", locations?.last?.longDescription ?? "nil")
            XCTAssertTrue(locations?.last?.coordinates?.lat == "-1.0967", locations?.last?.coordinates?.lat ?? "nil")
            XCTAssertTrue(locations?.last?.coordinates?.long == "53.214", locations?.last?.coordinates?.long ?? "nil")
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
            let object = objectClass.object(withId: objectId) {
            
            return object
        }
        fatalError("Couldn't parse neighbourhood")
    }

}