//
//  CrimeViewModelTest.swift
//  PoliceTests
//
//  Created by Riccardo on 17/04/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import XCTest
import CoreData
import SwiftyJSON
@testable import Police

class CrimeViewModelTest: XCTestCase {
    
    var crime: Crime!
    var container: NSPersistentContainer?

    override func setUp() {
        
        if container == nil {
            container = CoreDataManager.shared.container
        }
    }
    
    func setUpCrime(withOutcome: Bool) {
        crime = Crime(context: container!.viewContext)
        let jsonFile = withOutcome ? JSONFile.Crimes.crime : JSONFile.Crimes.crimeNoOutcome
        let data = FileExtractor.extractJsonFile(withName: jsonFile, forClass: type(of: self))
        let json = try! JSON(data: data)
        crime.update(with: json)
    }

    override func tearDown() {
        container = nil
    }
    
    
    func testCrimeViewModel() {
        
        setUpCrime(withOutcome: false)
        var viewModel = CrimeViewModel(with: crime)
        
        XCTAssert(viewModel.items.count == 3)
        XCTAssert(viewModel.items[0].rowCount == 1)
        XCTAssert(viewModel.items[1].rowCount == 1)
        XCTAssert(viewModel.items[2].rowCount == 1)
        
        XCTAssert(viewModel.items[0].sectionTitle == "")
        XCTAssert(viewModel.items[1].sectionTitle == "Period")
        XCTAssert(viewModel.items[2].sectionTitle == "Location")
        
        XCTAssert(viewModel.items[0].type == .summary)
        XCTAssert(viewModel.items[1].type == .period)
        XCTAssert(viewModel.items[2].type == .locationDetails)
        
        setUpCrime(withOutcome: true)
        viewModel = CrimeViewModel(with: crime)
        
        XCTAssert(viewModel.items.count == 4)
        XCTAssert(viewModel.items[0].rowCount == 1)
        XCTAssert(viewModel.items[1].rowCount == 1)
        XCTAssert(viewModel.items[2].rowCount == 1)
        XCTAssert(viewModel.items[3].rowCount == 1)
        
        XCTAssert(viewModel.items[0].sectionTitle == "")
        XCTAssert(viewModel.items[1].sectionTitle == "Period")
        XCTAssert(viewModel.items[2].sectionTitle == "Location")
        XCTAssert(viewModel.items[3].sectionTitle == "Outcome")

        XCTAssert(viewModel.items[0].type == .summary)
        XCTAssert(viewModel.items[1].type == .period)
        XCTAssert(viewModel.items[2].type == .locationDetails)
        XCTAssert(viewModel.items[3].type == .outcome)
    }
    
    func testCellViewModel() {
        
        
        
        
    }

 

}
