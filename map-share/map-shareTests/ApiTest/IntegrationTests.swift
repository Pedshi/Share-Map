//
//  IntegrationTests.swift
//  map-shareTests
//
//  Created by Pedram Shirmohammad on 2021-03-24.
//

import XCTest
@testable import map_share

class integrationTests: XCTestCase {
    
    let testEmail = "test@email.com"
    let testPassword = "testPass"
    let enctryptedPass = "testPass".data(using: .utf8)
    let testToken = "testToken"
    var cookie : [String: String] {
        ["Set-Cookie" : "_t=" + testToken + ";"]
    }
    var kCMock : MockKeyChain!
    var session : URLSession!
    
    override func setUpWithError() throws {
        let conf = URLSessionConfiguration.default
        conf.protocolClasses = [MockSession.self]
        session = URLSession(configuration: conf)
        kCMock = MockKeyChain()
        kCMock.setReadResponse(status: errSecItemNotFound, result: nil)
        mockKCToken(keyChain: kCMock)
        mockKCPassword(keyChain: kCMock)
    }
    
    func test_loginSavePasswrdNoToken_success() throws {
        MockSession.response = try MockResponse.mock()
        _ = try await(API.User.loginRequest(
                            email: testEmail,
                            password: testPassword,
                            session: session
        ))
        let query = try XCTUnwrap(kCMock.saveQuery.first as [String: AnyObject])
        let password = query[kSecValueData as String] as! Data
        XCTAssertEqual(
            query[kSecAttrAccount as String] as! String,
            testEmail
        )
        XCTAssertEqual(
            String(decoding: password, as: UTF8.self),
            testPassword
        )
    }
    
    func test_loginSaveTokenAndPasswrd_success() throws {
        MockSession.response = try MockResponse.mock(headers: cookie)
        
        XCTAssertNoThrow(
            try await(API.User.loginRequest(
                        email: testEmail,
                        password: testPassword,
                        session: session
            ))
        )
        
        let lastQuery = try XCTUnwrap(kCMock.saveQuery.popLast() as [String: AnyObject])
        let password = lastQuery[kSecValueData as String] as! Data
        XCTAssertEqual(
            lastQuery[kSecAttrAccount as String] as! String,
            testEmail
        )
        XCTAssertEqual(
            String(decoding: password, as: UTF8.self),
            testPassword
        )
        
        let firstQuery = try XCTUnwrap(kCMock.saveQuery.popLast() as [String: AnyObject])
        let token = firstQuery[kSecValueData as String] as! Data
        XCTAssertEqual(
            firstQuery[kSecAttrAccount as String] as! String,
            testEmail
        )
        XCTAssertEqual(
            String(decoding: token, as: UTF8.self),
            testToken
        )
    }
    
    func test_loginFailNoKCSave_success () throws {
        MockSession.response = try MockResponse.mock(success: false)
        XCTAssertThrowsError(
            try await(API.User.loginRequest(
                        email: testEmail,
                        password: testPassword,
                        session: session
            ))
        )
        XCTAssertNil(kCMock.saveQuery.popLast())
    }
    
    func mockKCPassword(keyChain: MockKeyChain) {
        KeyChainManager.Passwrd = KeyChainManager(
                label: "TESTPASSWORD",
                type: 1,
                service: "tesPassword",
                keyChain: keyChain
        )
    }
    
    func mockKCToken(keyChain: MockKeyChain){
        KeyChainManager.Token = KeyChainManager(
            label: "TESTTOKEN",
            type: 2,
            service: "testToken",
            keyChain: keyChain
        )
    }
    
    override func tearDownWithError() throws {
        kCMock = nil
    }
    
}
