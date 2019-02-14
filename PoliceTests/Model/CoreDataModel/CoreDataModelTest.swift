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
        
       var data = FileExtractor.extractJsonFile(withName: "Crime", forClass: type(of: self))
        
        updateCrime(withData: data) { [weak self] in

            let crime = self?.savedCrime(from: data)
            XCTAssertTrue(crime!.locationTypeCode == "Force")
        }
        
        data = FileExtractor.extractJsonFile(withName: "CrimeEdited", forClass: type(of: self))
        
        updateCrime(withData: data) { [weak self] in
            
            let crime = self?.savedCrime(from: data)
            XCTAssertTrue(crime!.locationTypeCode == "Travel")
            XCTAssertTrue(crime!.coordinates!.lat == "52.640961")
            XCTAssertTrue(crime!.coordinates!.long == "-1.126371")
        }
    }
    
    func updateCrime(withData data: Data, completion: @escaping () -> Void) {
        
        let expectation = self.expectation(description: "Crime processing")
        
        UpdateProcessor.updateCrime(fromData: data) { (completed) in
            
            expectation.fulfill()
        }
        waitForExpectations(timeout: 3, handler: nil)
        completion()
    }

    func savedCrime(from data: Data) -> Crime {
        
        if let crimeId = try! JSON(data: data)[Crime.dataIdentifier].number?.stringValue,
            let crime = Crime.object(withId: crimeId) {
            return crime
        }
        fatalError("crime not parsed")
    }

}
