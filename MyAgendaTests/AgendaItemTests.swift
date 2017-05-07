//
//  AgendaItemTests.swift
//  MyAgenda
//
//  Created by Mike Vork on 4/21/17.
//  Copyright © 2017 Mike Vork. All rights reserved.
//

import XCTest
@testable import MyAgenda


class AgendaItemTests: XCTestCase {
    
    var modelController: ModelController!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        modelController = ModelController.sharedInstance

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testNewAgendaItem_PropertiesAreSet() {
        let date = Date(timeIntervalSince1970: 10000000.0)  // 4/26/1970

        let item = modelController.addAgendaItem(descriptionText: "New Item", category: "New Category", priority: 2, dueDate: date)
        
        XCTAssertEqual(item?.descriptionText, "New Item")
        XCTAssertEqual(item?.category, "New Category")
        XCTAssertEqual(item?.priority, 2)
        XCTAssertEqual(item?.dueDate, date as NSDate)
    }
}
