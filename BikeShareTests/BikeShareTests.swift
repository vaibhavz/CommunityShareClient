//
//  BikeShareTests.swift
//  BikeShareTests
//
//  Created by Joyal Serrao on 20/10/18.
//  Copyright © 2018 Joyal. All rights reserved.
//

import XCTest
@testable import BikeShare

class BikeShareTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        TransportNetworkRequest.getRequestofType(.allBike, headers: [:], urlParams: [:])
        
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
