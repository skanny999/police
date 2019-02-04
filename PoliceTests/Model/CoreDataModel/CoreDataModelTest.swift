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

            XCTAssertTrue(self?.crimeProperty(forKey: "id", from: data, isEqualTo: "Force") ?? false)
        }
        
        data = FileExtractor.extractJsonFile(withName: "CrimeEdited", forClass: type(of: self))
        
        updateCrime(withData: data) { [weak self] in
            
            XCTAssertTrue(self?.crimeProperty(forKey: "id", from: data, isEqualTo: "Travel") ?? false)
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
    
    func crimeProperty(forKey key: String, from data: Data, isEqualTo string: String) -> Bool {
        
        let crimeId = try! JSON(data: data)[key].number?.stringValue
//        print("Crimelocation: \(Crime.object(withId: crimeId)?.locationTypeCode)")
        
        return Crime.object(withId: crimeId!)?.locationTypeCode == string
    }
}
