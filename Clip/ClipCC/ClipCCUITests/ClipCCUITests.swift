//
//  ClipCCUITests.swift
//  ClipCCUITests
//
//  Created by Karl Pfister on 3/12/18.
//  Copyright © 2018 Karl Pfister. All rights reserved.
//

import XCTest

class ClipCCUITests: XCTestCase {
    
    var app: XCUIApplication!
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        //XCUIApplication().launch()
        app = XCUIApplication()
        

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        
    }
    
    // MARK: - Tests
    
    func testParsingData() {
        // Launch the app
       app.launch()
        // Make sure its showing the MainVC
        XCTAssertTrue(app.isDisplayingMainVC)
        // Tap the execute button to begin parsing the data
        app.buttons["Execute"].tap()
        // It works if It is no longer displaying the Main VC
        XCTAssertFalse(app.isDisplayingMainVC)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    
}

extension XCUIApplication {
    var isDisplayingMainVC: Bool {
        return otherElements["MainVC"].exists
    }
}
