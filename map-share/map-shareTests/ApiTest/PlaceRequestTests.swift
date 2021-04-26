//
//  PlaceRequestTests.swift
//  map-shareTests
//
//  Created by Pedram Shirmohammad on 2021-03-23.
//

import XCTest
import Combine
@testable import map_share

class PlaceRequestTests: XCTestCase {
    
    let testToken = "testToken"
    var session : URLSession!
    
    override func setUpWithError() throws {
        let conf = URLSessionConfiguration.default
        conf.protocolClasses = [MockSession.self]
        session = URLSession(configuration: conf)
    }
    
    func test_placeFetch_shouldSucceed () throws {
        MockSession.response = try MockResponse.mock()
        XCTAssertNoThrow(
            try await(API.Place.fetchPlacesRequest(token: testToken, session: session))
        )
    }
    
    func test_placeFetch_reponseData () throws {
        let input = [
            "name" : "placeName"
        ]
        let json = try JSONSerialization.data(withJSONObject: input, options: [])
        MockSession.response = try MockResponse.mock(data: json)
        let response = try await(API.Place.fetchPlacesRequest(token: testToken, session: session))
        let result = try JSONSerialization.jsonObject(with: response, options: []) as? [String: String]
        let resultName = try XCTUnwrap(result)["name"]
        XCTAssertEqual(resultName, input["name"])
    }
    
}
