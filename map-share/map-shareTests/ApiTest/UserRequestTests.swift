//
//  UserRequestTests.swift
//  map-shareTests
//
//  Created by Pedram Shirmohammad on 2021-03-17.
//

import XCTest
import Combine
@testable import map_share

class UserRequestTests: XCTestCase {
    
    let testEmail = "test@email.com"
    let testPassword = "testPass"
    let testToken = "testToken"
    var cookie : [String: String] {
        ["Set-Cookie" : "_t=" + testToken + ";"]
    }
    var session : URLSession!
    
    override func setUpWithError() throws {
        let conf = URLSessionConfiguration.default
        conf.protocolClasses = [MockSession.self]
        session = URLSession(configuration: conf)
    }
    
    func test_login_success() throws {
        MockSession.response = try MockResponse.mock()
        XCTAssertNoThrow(
            try await(API.User.loginRequest(
                    email: testEmail,
                    password: testPassword,
                    session: session,
                    KCManager: MockKeyChainManager.self
                ))
        )
    }
    
    func test_loginFail_throws() throws {
        MockSession.response = try MockResponse.mock(success: false)
        XCTAssertThrowsError(
            try await(API.User.loginRequest(
                        email: testEmail,
                        password: testPassword,
                        session: session,
                        KCManager: MockKeyChainManager.self
            ))
        )
    }
    
    func test_LoginKCSavePassword_success() throws {
        MockSession.response = try MockResponse.mock()
        _ = try await(API.User.loginRequest(
                    email: testEmail,
                    password: testPassword,
                    session: session,
                    KCManager: MockKeyChainManager.self
            ))
        let savedInfo = try MockKeyChainManager.Passwrd.readItem()
        XCTAssertEqual(savedInfo.account, testEmail)
        XCTAssertEqual(savedInfo.secretValue, testPassword)
    }
    
    func test_loginKCSaveToken_success() throws {
        MockSession.response = try MockResponse.mock(headers: cookie)
        _ = try await(API.User.loginRequest(
                    email: testEmail,
                    password: testPassword,
                    session: session,
                    KCManager: MockKeyChainManager.self
            ))
        let savedInfo = try MockKeyChainManager.Token.readItem()
        XCTAssertEqual(savedInfo.account, testEmail)
        XCTAssertEqual(savedInfo.secretValue, testToken)
    }
    
    func test_loginNoCookie_success() throws {
        MockSession.response = try MockResponse.mock()
        _ = try await(API.User.loginRequest(
                    email: testEmail,
                    password: testPassword,
                    session: session,
                    KCManager: MockKeyChainManager.self
            ))
        let savedInfo = try MockKeyChainManager.Token.readItem()
        XCTAssertEqual(savedInfo.account, "")
        XCTAssertEqual(savedInfo.secretValue, "")
    }

    func test_loginKCSaveLowerCase_success() throws {
        MockSession.response = try MockResponse.mock(headers: cookie)
        _ = try await(API.User.loginRequest(
                    email: "TeSt@email.com",
                    password: testPassword,
                    session: session,
                    KCManager: MockKeyChainManager.self
            ))
        let savedPassword = try MockKeyChainManager.Passwrd.readItem()
        let savedToken = try MockKeyChainManager.Token.readItem()
        XCTAssertEqual(savedPassword.account, testEmail)
        XCTAssertEqual(savedToken.account, testEmail)
    }
    
    func test_validateToken_success() throws {
        MockSession.response = try MockResponse.mock()
        XCTAssertNoThrow(
            try await(API.User.validateTokenRequest(
                        email: testToken,
                        token: testToken,
                        session: session
            ))
        )
    }
    
    func test_validateWrongToken_fail() throws {
        MockSession.response = try MockResponse.mock(success: false)
        XCTAssertThrowsError(
            try await(API.User.validateTokenRequest(
                        email: testToken,
                        token: testToken,
                        session: session
            ))
        )
    }
    
    func testTrimCookieSucc() throws {
        let cookie = "_t=eyJhbGciOiJ.rre; Path=/; HttpOnly"
        let ret = UserRequest.trimCookie(cookie: cookie)
        XCTAssertEqual(ret, "eyJhbGciOiJ.rre")
    }
    
    override func tearDownWithError() throws {
        try MockKeyChainManager.Token.saveItem(account: "", secretValue: "")
        try MockKeyChainManager.Passwrd.saveItem(account: "", secretValue: "")
    }
}

extension XCTestCase {
    
    @discardableResult 
    func await<T: Publisher>(_ publisher: T) throws -> T.Output {
        
        var result: Result<T.Output, Error>?
        let expectation = self.expectation(description: "Publisher running")

        let cancellable = publisher.sink(
            receiveCompletion: { completion in
                switch completion{
                case let .failure(encounteredError):
                    result = .failure(encounteredError)
                case .finished:
                    break
                }
                expectation.fulfill()
            },
            receiveValue: { value in
                result = .success(value)
            }
        )
        
        waitForExpectations(timeout: 10)
        cancellable.cancel()
        
        return try XCTUnwrap(result).get()
    }
}
