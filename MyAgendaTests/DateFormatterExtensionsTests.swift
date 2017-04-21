//
//  DateFormatterExtensionsTests.swift
//  MyAgenda
//
//  Created by Mike Vork on 4/14/17.
//  Copyright © 2017 Mike Vork. All rights reserved.
//

import XCTest
@testable import MyAgenda


class DateFormatterExtensionsTests: XCTestCase {
    
    var dateFormatter: DateFormatter!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        dateFormatter = DateFormatter()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDateFormats() {
        
        let date = Date(timeIntervalSince1970: 10000000.0)  // 4/26/1970
        var formattedString = dateFormatter.getString(from: date, with: "M/d/y")
        XCTAssertEqual(formattedString, "4/26/1970")
        
        formattedString = dateFormatter.getString(from: date, with: "MM/dd/yyyy")
        XCTAssertEqual(formattedString, "04/26/1970")
        
        let date2 = Date(timeIntervalSince1970: 1000000000.0)  // 9/8/2001
        formattedString = dateFormatter.getString(from: date2, with: "M/d/y")
        XCTAssertEqual(formattedString, "9/8/2001")
        
        formattedString = dateFormatter.getString(from: date2, with: "MM/dd/yyyy")
        XCTAssertEqual(formattedString, "09/08/2001")

        
    }
    
}
