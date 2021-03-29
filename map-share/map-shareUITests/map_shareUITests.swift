//
//  map_shareUITests.swift
//  map-shareUITests
//
//  Created by Pedram Shirmohammad on 2021-03-08.
//

import XCTest

class map_shareUITests: XCTestCase {
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testExample() throws {
        let app = XCUIApplication()
        app.launch()
        let emailField = app.textFields["loginEmailField"]
        let passwordField = app.secureTextFields["loginPasswordField"]
        
        emailField.tap()
        emailField.typeText("pedram.shir@hotmail.com\n")
        passwordField.tap()
        passwordField.typeText("p1e2d3r4a5m6\n")
        app.buttons.element.tap()
        
        XCTAssertTrue(app.maps.element.waitForExistence(timeout: 10))
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
