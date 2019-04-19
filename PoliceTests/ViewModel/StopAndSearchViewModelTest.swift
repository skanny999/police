//
//  StopAndSearchViewModelTest.swift
//  PoliceTests
//
//  Created by Riccardo on 17/04/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import XCTest
import CoreData
import SwiftyJSON
@testable import Police

class StopAndSearchViewModelTest: XCTestCase {
    
    var stopAndSearch: StopAndSearch?
    var container: NSPersistentContainer?

    override func setUp() {
        if container == nil {
            container = CoreDataManager.shared.container
        }
        createStopAndSearch()
    }

    override func tearDown() {
        container = nil
    }
    
    func createStopAndSearch() {
        
        stopAndSearch = StopAndSearch(context: container!.viewContext)
        let data = FileExtractor.extractJsonFile(withName: JSONFile.StopAndSearch.original, forClass: type(of: self))
        let json = try! JSON(data: data).array
        StopAndSearch.update(stopAndSearch!, with: json!.first!)
    }

    func testStopAndSearchViewModel() {
        
        let viewModel = StopAndSearchViewModel(with: stopAndSearch!)
        XCTAssert(viewModel.items.count == 4)
        
        XCTAssert(viewModel.items.count == 4)
        XCTAssert(viewModel.items[0].rowCount == 1)
        XCTAssert(viewModel.items[1].rowCount == 1)
        XCTAssert(viewModel.items[2].rowCount == 1)
        XCTAssert(viewModel.items[3].rowCount == 1)
        
        XCTAssert(viewModel.items[0].sectionTitle == "Object of Search")
        XCTAssert(viewModel.items[1].sectionTitle == "Suspect")
        XCTAssert(viewModel.items[2].sectionTitle == "Location")
        XCTAssert(viewModel.items[3].sectionTitle == "Outcome")
        
        XCTAssert(viewModel.items[0].type == .details)
        XCTAssert(viewModel.items[1].type == .suspect)
        XCTAssert(viewModel.items[2].type == .datePlace)
        XCTAssert(viewModel.items[3].type == .outcome)
    }

}
