//
//  LoginViewModelTests.swift
//  map-shareTests
//
//  Created by Pedram Shirmohammad on 2021-03-17.
//

import XCTest
import Combine
@testable import map_share

class LoginViewModelTests: XCTestCase {
    
    enum LoginFlowErr : Error {
        case notAuthenticating
        case notAuthenticationFail
        case notAuthenticated
        case notRefreshinToken
        case notInIdle
        case notLoggingIn
    }
    
    let email = "pedram.shir@hotmail.com"
    let correctPassword = "p1e2d3r4a5m6"
    let wrongToken = "1273.944"
//    
//    func testAuthNoToken() throws {
//        let statePublisher = LoginViewModel().$state.collectNext(2)
//        let stateArray = try await(statePublisher)
//        
//        guard case .authenticating = stateArray[0] else {throw LoginFlowErr.notAuthenticating}
//        guard case .idle = stateArray[1] else {throw LoginFlowErr.notInIdle}
//    }
//    
//    func testRefreshToken() throws {
//        // Mock Key Chain password and expired token
//        XCTAssertNoThrow(
//            try KeyChainManager.Passwrd.saveItem(secretValue: correctPassword, account: email)
//        )
//        XCTAssertNoThrow(
//            try KeyChainManager.Token.saveItem(secretValue: wrongToken, account: email)
//        )
//        // LoginViewModel needs to be instantiated after Key Chain items are created
//        let statePublisher = LoginViewModel().$state.collectNext(3)
//        let stateArray = try await(statePublisher)
//        
//        guard case .authenticating = stateArray[0] else{throw LoginFlowErr.notAuthenticating}
//        guard case .refreshingToken = stateArray[1] else{throw LoginFlowErr.notRefreshinToken}
//        guard case .authenticated = stateArray[2] else{throw LoginFlowErr.notAuthenticated}
//    }
//    
//    func testLoginForm() throws {
//        let viewModel = LoginViewModel()
//        // Wait for authentication to fail
//        let authPublisher = viewModel.$state.collectNext(2)
//        let _ = try await(authPublisher)
//        
//        let loginPublisher = viewModel.$state.collectNext(3)
//        // Must send to event before we await the publisher
//        viewModel.send(event: .onLoginReq(email: email, password: correctPassword))
//        let loginStates = try await(loginPublisher)
//        
//        guard case .idle = loginStates[0] else{throw LoginFlowErr.notInIdle}
//        guard case .loggingIn = loginStates[1] else{throw LoginFlowErr.notLoggingIn}
//        guard case .authenticated = loginStates[2] else{throw LoginFlowErr.notAuthenticated}
//    }
//
//
//    override func tearDownWithError() throws {
//        var queryPswrd = [String: AnyObject]()
//        queryPswrd[kSecClass as String] = kSecClassGenericPassword
//        queryPswrd[kSecAttrType as String] = 11 as AnyObject?
//        queryPswrd[kSecAttrLabel as String] = "Password" as AnyObject?
//        queryPswrd[kSecAttrService as String] = "com.map-share.password" as AnyObject?
//        queryPswrd[kSecAttrAccount as String] = email as AnyObject?
//        
//        _ = SecItemDelete(queryPswrd as NSDictionary)
//        
//        var queryToken = [String: AnyObject]()
//        queryToken[kSecClass as String] = kSecClassGenericPassword
//        queryToken[kSecAttrType as String] = 22 as AnyObject?
//        queryToken[kSecAttrLabel as String] = "Token" as AnyObject?
//        queryToken[kSecAttrService as String] = "com.map-share.token" as AnyObject?
//        queryToken[kSecAttrAccount as String] = email as AnyObject?
//        
//        _ = SecItemDelete(queryToken as NSDictionary)
//    }
    
}

extension Published.Publisher {
    func collectNext(_ count: Int) -> AnyPublisher<[Output], Never> {
        self.collect(count)
            .first()
            .eraseToAnyPublisher()
    }
}
