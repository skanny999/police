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
        
        let request = Crime.sortedFetchRequest
        let objects = try! mockContainer?.viewContext.fetch(request)
        
        for case let object as NSManagedObject in objects! {
            
            mockContainer?.viewContext.delete(object)
        }
    }
    
    // Test crime object
    
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
            
            let outcomes = crime?.outcomes?.sorted{$0.date! < $1.date!}

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
        
        let data = FileExtractor.extractJsonFile(withName: JSONFile.Neighbourhood.specificNeighbourhood, forClass: type(of: self))
        
        let longDescription = "<p>The Castle neighbourhood is a diverse covering all of the City Centre. In addition it covers De Montfort University, the University of Leicester, Leicester Royal Infirmary, the Leicester Tigers rugby ground and the Clarendon Park and Riverside communities.</p>\n<p>The Highcross and Haymarket shopping centres and Leicester's famous Market are all covered by this neighbourhood.</p>"

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
            
//            {
//                "name": "Mansfield House",
//                "longitude": null,
//                "postcode": "LE1 3GG",
//                "address": "74 Belgrave Gate\n, Leicester",
//                "latitude": null,
//                "type": "station",
//                "description": null
//            }
            
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
