//
//  ExtensionTests.swift
//  map-shareTests
//
//  Created by Pedram Shirmohammad on 2021-03-30.
//

import XCTest
@testable import map_share

class ExtensionTests: XCTestCase {
    
    var date = Date()
    var calendar = Calendar(identifier: .gregorian)
    var offset: Int!
    
    override func setUpWithError() throws {
        let currentDay = try XCTUnwrap(calendar.component(.weekday, from: date))
        offset = 7 - currentDay
    }
    
    func test_DateGetSun_Success() throws {
        let date2 = try XCTUnwrap( calendar.date(byAdding: .weekday, value: offset + 1, to: date) )
        let day = calendar.component(.weekday, from: date2)
        XCTAssertEqual("sun", Date.weekDayList[day - 1])
    }
    
    func test_DateGetMon_Success() throws {
        let date2 = try XCTUnwrap( calendar.date(byAdding: .weekday, value: offset + 2, to: date) )
        let day = calendar.component(.weekday, from: date2)
        XCTAssertEqual("mon", Date.weekDayList[day - 1])
    }
    
    func test_DateGetTue_Success() throws {
        let date2 = try XCTUnwrap( calendar.date(byAdding: .weekday, value: offset + 3, to: date) )
        let day = calendar.component(.weekday, from: date2)
        XCTAssertEqual("tue", Date.weekDayList[day - 1])
    }
    
    func test_DateGetWed_Success() throws {
        let date2 = try XCTUnwrap( calendar.date(byAdding: .weekday, value: offset + 4, to: date) )
        let day = calendar.component(.weekday, from: date2)
        XCTAssertEqual("wed", Date.weekDayList[day - 1])
    }
    
    func test_DateGetThu_Success() throws {
        let date2 = try XCTUnwrap( calendar.date(byAdding: .weekday, value: offset + 5, to: date) )
        let day = calendar.component(.weekday, from: date2)
        XCTAssertEqual("thu", Date.weekDayList[day - 1])
    }
    
    func test_DateGetFri_Success() throws {
        let date2 = try XCTUnwrap( calendar.date(byAdding: .weekday, value: offset + 6, to: date) )
        let day = calendar.component(.weekday, from: date2)
        XCTAssertEqual("fri", Date.weekDayList[day - 1])
    }
    
    func test_DateGetSat_Success() throws {
        let date2 = try XCTUnwrap( calendar.date(byAdding: .weekday, value: offset + 7, to: date) )
        let day = calendar.component(.weekday, from: date2)
        XCTAssertEqual("sat", Date.weekDayList[day - 1])
    }
}
