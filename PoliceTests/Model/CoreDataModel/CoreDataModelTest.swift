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
        
        updateObject(type: Neighbourhood.self, withData: data) {
            
            // write tests
            
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
        
        if let objectId = try! JSON(data: data)[objectClass.dataIdentifier].number?.stringValue,
            let object = objectClass.object(withId: objectId){
            
            return object
        }
        fatalError("Couldn't parse neighbourhood")
    }

}
