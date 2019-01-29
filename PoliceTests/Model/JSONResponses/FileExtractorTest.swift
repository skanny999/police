//
//  FileExtractorTest.swift
//  PoliceTests
//
//  Created by Riccardo on 29/01/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import XCTest
@testable import Police

class FileExtractorTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFileExtractor() {
        
        let data = FileExtractor.extractJsonFile(withName:"ListOfForces", forClass: type(of: self))
        
        XCTAssertNotNil(data)
    }

}
