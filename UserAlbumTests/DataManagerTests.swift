//
//  DataManagerTests.swift
//  UserAlbum
//
//  Created by Florian Heiber on 17.03.16.
//  Copyright © 2016 Florian Heiber. All rights reserved.
//

import XCTest

class DataManagerTests: XCTestCase {
    var dataManager: DataManager? = nil
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        dataManager = DataManager()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInitialization() {
        XCTAssertNotNil(dataManager, "Should be initialized at this point")
    }
}
