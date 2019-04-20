//
//  StopAndSearchCellViewModel.swift
//  PoliceTests
//
//  Created by Riccardo on 19/04/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import XCTest
import CoreData
import SwiftyJSON
@testable import Police

class StopAndSearchCellViewModel: XCTestCase {

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
    
    func testStopAndSearchCell() {
        
        let viewModel = StopAndSearchViewModel(with: stopAndSearch!)
        
        for item in viewModel.items {
            
            switch item.type {
            case .details:
                let details = item as! StopAndSearchViewModelDescription
                XCTAssert(details.description == "Controlled drugs")
                XCTAssert(details.legislation == "Misuse of Drugs Act 1971 (section 23)")
                XCTAssert(details.image == UIImage(named: "crime-selected"))
            case .suspect:
                let suspect = item as! StopAndSearchViewModelSuspect
                XCTAssert(suspect.gender == "Male")
                XCTAssert(suspect.age == "over 34")
                XCTAssert(suspect.ethnicity == "White British")
            case .datePlace:
                let datePlace = item as! StopAndSearchViewModelDatePlace
                XCTAssert(datePlace.place == "On or near Severn Road")
            case .outcome:
                let outcome = item as! StopAndSearchViewModelOutcome
                XCTAssert(outcome.outcome == "A no further action disposal")
            case .summary:
                break
            }
        }
    }
}
