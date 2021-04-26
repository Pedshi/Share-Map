//
//  map_shareUITests.swift
//  map-shareUITests
//
//  Created by Pedram Shirmohammad on 2021-03-08.
//

import Foundation

import XCTest

class map_shareUITests: XCTestCase {
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    
    func testLaunchPerformance() throws {
            if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
                // This measures how long it takes to launch your application.
                measure(metrics: [XCTApplicationLaunchMetric()]) {
                    XCUIApplication().launch()
                }
            }
        }
}
