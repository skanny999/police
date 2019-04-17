//
//  CrimeCellViewModel.swift
//  PoliceTests
//
//  Created by Riccardo on 17/04/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import XCTest
import CoreData
import SwiftyJSON
@testable import Police

class CrimeCellViewModel: XCTestCase {
    
    var crime: Crime!
    var container: NSPersistentContainer?
    
    override func setUp() {
        
        if container == nil {
            container = CoreDataManager.shared.container
        }
        setUpCrime()
    }
    
    func setUpCrime() {
        crime = Crime(context: container!.viewContext)
        let data = FileExtractor.extractJsonFile(withName: JSONFile.Crimes.crime, forClass: type(of: self))
        let json = try! JSON(data: data)
        crime.update(with: json)
    }
    
    override func tearDown() {
        container = nil
    }
    
    func testCrimeCells() {
        
        let crimeViewModel = CrimeViewModel(with: crime)
        
        for item in crimeViewModel.items {
            
            switch item.type {
            case .summary:
                let item = item as! CrimeViewModelSummary
                XCTAssert(item.crimes.first == crime)
                
            case .period:
                let item = item as! CrimeViewModelPeriod
                XCTAssert(item.period == "January 2017")
                
            case .locationDetails:
                let item = item as! CrimeViewModelLocation
                XCTAssert(item.location == "On or near Wharf Street North")
                
            case .outcome:
                let item = item as! CrimeViewModelOutcome
                XCTAssert(item.outcomes.first == crimeViewModel.outcomes(for: crime)?.first)
            }
        }
    }
}
