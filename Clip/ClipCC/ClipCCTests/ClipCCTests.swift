//
//  ClipCCTests.swift
//  ClipCCTests
//
//  Created by Karl Pfister on 3/12/18.
//  Copyright © 2018 Karl Pfister. All rights reserved.
//

import XCTest
@testable import ClipCC


class ClipCCTests: XCTestCase {
    
    var testingEMVData: [TransactionDetail]!
    
    var testingParser: String!
    
    
    
    override func setUp() {
        super.setUp()
       
        testingParser = "5F201A54444320424C41434B20554E4C494D4954454420564953412020"
        
       
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        testingEMVData = nil
        testingParser = nil
        
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Parse the data
        Parser.sharedInstance.parseTransactions(tlvString: testingParser)
        testingEMVData = Parser.sharedInstance.transactions
        
        if testingEMVData.count != 0 {
            print("Pass")
        } else {
            print("Fail")
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
