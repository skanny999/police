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
    
    func testPeriodsCreation() {
        
        let currentPeriodString = "2017-01-01"
        
        let currentPeriod: Date = currentPeriodString.periodDate!
        let correctPeriodDate = Date.date(fromDay: 01, month: 01, year: 2017)
        
        XCTAssertTrue(currentPeriod == correctPeriodDate)
        
        let availablePeriods: [Date] = currentPeriod.previousAvailableDates()
        
        var correctPeriods = [Const.firstPeriod]
        correctPeriods.append(Date.date(fromDay: 01, month: 03, year: 2016))
        correctPeriods.append(Date.date(fromDay: 01, month: 04, year: 2016))
        correctPeriods.append(Date.date(fromDay: 01, month: 05, year: 2016))
        correctPeriods.append(Date.date(fromDay: 01, month: 06, year: 2016))
        correctPeriods.append(Date.date(fromDay: 01, month: 07, year: 2016))
        correctPeriods.append(Date.date(fromDay: 01, month: 08, year: 2016))
        correctPeriods.append(Date.date(fromDay: 01, month: 09, year: 2016))
        correctPeriods.append(Date.date(fromDay: 01, month: 10, year: 2016))
        correctPeriods.append(Date.date(fromDay: 01, month: 11, year: 2016))
        correctPeriods.append(Date.date(fromDay: 01, month: 12, year: 2016))
        correctPeriods.append(Date.date(fromDay: 01, month: 01, year: 2017))
        
        XCTAssertTrue(availablePeriods == correctPeriods)
    }


    func testPeriodStruct() {
        
        let period1 = DatePeriod(fromMonth: "2016-12")
        
        XCTAssertTrue(period1!.month == "12")
        XCTAssertTrue(period1!.year == "2016")
        
        let badMonthStrings: [String?] = ["erwerw", nil, "98-4-445", "4345-54", "345-ss"]
        
        for monthString in badMonthStrings {
            
            let period = DatePeriod(fromMonth: monthString)
            XCTAssertNil(period)
        } 
    }

}
