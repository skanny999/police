//
//  PersistentContainerTest.swift
//  PoliceTests
//
//  Created by Riccardo on 31/01/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import XCTest
import CoreData
@testable import Police


class PersistentContainerTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        
        let persistentContainer = CoreDataManager.shared.container
        
        XCTAssert(persistentContainer.persistentStoreDescriptions.first?.type == NSInMemoryStoreType)
        
    }
}
