//
//  UserEndpointTests.swift
//  map-shareTests
//
//  Created by Pedram Shirmohammad on 2021-03-22.
//

import XCTest
@testable import map_share

class EndPointsTests: XCTestCase {
    
    var testUrl = try! XCTUnwrap(URL(string: "http://localhost:3001/api/anvandare/loggain?"))
    var testRequest : URLRequest!
    
    override func setUpWithError() throws {
        testRequest = URLRequest(url: testUrl)
    }
    
    func test_getMethod_shouldNotChangeUrl() throws {
        RequestMethod.Get.setBody(request: &testRequest, data: nil)
        XCTAssertEqual(testRequest.httpBody, nil)
        
    }
    
    func test_postMethod_shouldAddBody() throws {
        let data = [
            "email": "testEmail",
            "password" : "testPassword"
        ]
        let json = try JSONSerialization.data(withJSONObject: data, options: [])
        RequestMethod.Post.setBody(request: &testRequest, data: json)
        XCTAssertEqual(testRequest.url, testUrl)
        XCTAssertEqual(testRequest.httpBody, json)
        XCTAssertEqual(testRequest.httpMethod, "POST")
    }
    
    func test_postMethod_shouldSetNil() throws {
        RequestMethod.Post.setBody(request: &testRequest, data: nil)
        XCTAssertEqual(testRequest.url, testUrl)
        XCTAssertEqual(testRequest.httpBody, nil)
        XCTAssertEqual(testRequest.httpMethod, "POST")
    }
    
    func test_privateReq_shouldSetCookie() throws {
        let token = "token"
        RequestType.Private.prepare(request: &testRequest, data: "token")
        XCTAssertEqual(testRequest.value(forHTTPHeaderField: "Cookie"), "_t="+token)
        XCTAssertEqual(testRequest.url, testUrl)
    }
    
    func test_withoutQueryItems() throws {
        let request = try XCTUnwrap(Endpoints.login.build(authData: nil, bodyData: nil))
        XCTAssertEqual( try XCTUnwrap(request.url), testUrl)
    }
    
    func test_withQueryItem_shouldSucceed() throws {
        let correctUrl = try XCTUnwrap(URL(string: "http://localhost:3001/api/anvandare/loggain?user=tstUser"))
        let queryItems = [
            URLQueryItem(name: "user", value: "tstUser")
        ]
        let newEndpoint = Endpoints<RequestType.Public, RequestMethod.Get>(path: "anvandare/loggain", queryItems: queryItems)
        let request = try XCTUnwrap(newEndpoint.build(authData: nil, bodyData: nil))
        XCTAssertEqual(request.url, correctUrl)
        XCTAssertEqual(request.cachePolicy, .reloadIgnoringCacheData)
    }
    
    func test_privateEndpoint_shouldSucceed() throws {
        let token = "token"
        let newEndpoint = Endpoints<RequestType.Private, RequestMethod.Get>(path: "anvandare/loggain", queryItems: [])
        let request = try XCTUnwrap(newEndpoint.build(authData: token, bodyData: nil))
        XCTAssertEqual(request.value(forHTTPHeaderField: "Cookie"), "_t="+token)
    }
    
    override func tearDownWithError() throws {
        testRequest = nil
    }
}
