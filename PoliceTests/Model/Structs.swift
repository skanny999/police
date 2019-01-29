//
//  Structs.swift
//  PoliceTests
//
//  Created by Riccardo on 29/01/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import XCTest
@testable import Police

class Structs: XCTestCase {

    override func setUp() {
        
    }

    override func tearDown() {
        
    }


    func testPeriodStruct() {
        
        let period1 = Period(fromMonth: "2016-12")
        
        XCTAssertTrue(period1!.month == "12")
        XCTAssertTrue(period1!.year == "2016")
        
        let badMonthStrings: [String?] = ["erwerw", nil, "98-4-445", "4345-54", "345-ss"]
        
        for monthString in badMonthStrings {
            
            let period = Period(fromMonth: monthString)
            XCTAssertNil(period)
        } 
    }

}
