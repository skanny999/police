//
//  StopAndSearchModelTest.swift
//  PoliceTests
//
//  Created by Riccardo on 17/04/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import XCTest
import CoreData
import SwiftyJSON
@testable import Police

class StopAndSearchModelTest: XCTestCase {
    
    var mockContainer: NSPersistentContainer?
    
    override func setUp() {
        
        if mockContainer == nil {
            mockContainer = CoreDataManager.shared.container
        }
    }
    
    override func tearDown() {
        
        mockContainer = nil
    }
    
    
    func testStopAndSearchObject() {
        
        var data = dataFromFile(JSONFile.StopAndSearch.original)
        
        let firstExpectation = self.expectation(description: "StopAndSearch")
        
        UpdateProcessor.updateStopAndSearch(fromData: data) { (completed) in
            
            firstExpectation.fulfill()
            
            if let json = try? JSON(data: data).array?.first {
                let objectId = StopAndSearch.identifier(from: json)
                let stopAndSearch = StopAndSearch.object(withId: objectId, in: CoreDataManager.shared.container.viewContext)
                
                XCTAssertTrue(stopAndSearch?.ageRange == "over 34")
                XCTAssertTrue(stopAndSearch?.dateTime?.component.hour == 6)
                XCTAssertTrue(stopAndSearch?.genderCode == "Male")
                XCTAssertTrue(stopAndSearch?.legislation == "Misuse of Drugs Act 1971 (section 23)")
                XCTAssertTrue(stopAndSearch?.objectOfSearch == "Controlled drugs")
                XCTAssertTrue(stopAndSearch?.officerEthnicity == "White")
                XCTAssertTrue(stopAndSearch?.operationName == nil)
                XCTAssertTrue(stopAndSearch?.outCome == "A no further action disposal")
                XCTAssertTrue(stopAndSearch?.outcomeIsLinkedToSearch == false)
                XCTAssertTrue(stopAndSearch?.personIsInvolved == true)
                XCTAssertTrue(stopAndSearch?.stripSearch == false)
                XCTAssertTrue(stopAndSearch?.suspectEthnicity == "White - English/Welsh/Scottish/Northern Irish/British")
                XCTAssertTrue(stopAndSearch?.typeCode == "Person search")
                XCTAssertTrue(stopAndSearch?.latitude == 52.264860)
                XCTAssertTrue(stopAndSearch?.longitude == 0.699943)
                XCTAssertTrue(stopAndSearch?.streetName == "On or near Severn Road")
            }
        }
        
        waitForExpectations(timeout: 10, handler: nil)
        
        let secondExpectation = self.expectation(description: "sasSecond")
        
        data = dataFromFile(JSONFile.StopAndSearch.edited)
        
        UpdateProcessor.updateStopAndSearch(fromData: data) { (completed) in
            
            secondExpectation.fulfill()
            
            if let json = try? JSON(data: data).array?.first {
                let objectId = StopAndSearch.identifier(from: json)
                let stopAndSearch = StopAndSearch.object(withId: objectId, in: CoreDataManager.shared.container.viewContext)
                
                XCTAssertTrue(stopAndSearch?.ageRange == "over 34")
                XCTAssertTrue(stopAndSearch?.dateTime?.component.hour == 6)
                XCTAssertTrue(stopAndSearch?.genderCode == "Female")
                XCTAssertTrue(stopAndSearch?.legislation == "Misuse of Drugs Act 1971 (section 23)")
                XCTAssertTrue(stopAndSearch?.objectOfSearch == "Controlled drugs")
                XCTAssertTrue(stopAndSearch?.officerEthnicity == "White")
                XCTAssertTrue(stopAndSearch?.operationName == nil)
                XCTAssertTrue(stopAndSearch?.outCome == "A no further action disposal")
                XCTAssertTrue(stopAndSearch?.outcomeIsLinkedToSearch == false)
                XCTAssertTrue(stopAndSearch?.personIsInvolved == true)
                XCTAssertTrue(stopAndSearch?.stripSearch == false)
                XCTAssertTrue(stopAndSearch?.suspectEthnicity == "White - English/Welsh/Scottish/Northern Irish/British")
                XCTAssertTrue(stopAndSearch?.typeCode == "Person search")
                XCTAssertTrue(stopAndSearch?.latitude == 52.264860)
                XCTAssertTrue(stopAndSearch?.longitude == 0.699943)
                XCTAssertTrue(stopAndSearch?.streetName == "On or near Severn Road")
                
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    // MARK: - Helper
    
    func dataFromFile(_ fileName: String) -> Data {
        
        return FileExtractor.extractJsonFile(withName: fileName, forClass: type(of: self))
    }
    
}
