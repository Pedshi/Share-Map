//
//  KeyChainTests.swift
//  map-shareTests
//
//  Created by Pedram Shirmohammad on 2021-03-16.
//

import XCTest
@testable import map_share

class KeyChainManagerTests: XCTestCase {
    
    let testEmail = "test@email.com"
    let testPassword = "testPass"
    let enctryptedPass = "testPass".data(using: .utf8)
    var kCManager: KeyChainManager!
    var kCMock: MockKeyChain!
    
    override func setUpWithError() throws {
        kCMock = MockKeyChain()
        kCManager = KeyChainManager(
            label: "testLabel",
            type: 0,
            service: "test",
            keyChain: kCMock
        )
    }
    
    
    func test_readItem_success() throws {
        let result = [
            kSecAttrAccount as String: testEmail as Any,
            kSecValueData as String: enctryptedPass as Any
        ] as AnyObject
        kCMock.setReadResponse(result: result)
        let response = try kCManager.readItem()
        XCTAssertEqual(response.account , testEmail)
        XCTAssertEqual(response.secretValue, testPassword)
    }
    
    func test_readMissin_throws() throws {
        kCMock.setReadResponse(status: errSecItemNotFound, result: nil)
        do{
            _ = try kCManager.readItem()
            XCTAssert(false)
        }catch KeychainError.noItemFound{
            XCTAssert(true)
        }catch {
            XCTAssert(false)
        }
    }
    
    func test_readUnknowErr_throws() throws {
        kCMock.setReadResponse(status: errSecInvalidAction, result: nil)
        do{
            _ = try kCManager.readItem()
            XCTAssert(false)
        }catch KeychainError.unhandledError{
            XCTAssert(true)
        }catch {
            XCTAssert(false)
        }
    }
    
    func test_readNoResult_throws() throws {
        kCMock.readResult = nil
        do{
            _ = try kCManager.readItem()
            XCTAssert(false)
        }catch KeychainError.unexpectedItemData{
            XCTAssert(true)
        }catch {
            XCTAssert(false)
        }
    }
    
    func test_save_success() throws {
        kCMock.setReadResponse(status: errSecItemNotFound, result: nil)
        XCTAssertNoThrow(
            try kCManager.saveItem(account: testEmail, secretValue: testPassword)
        )
    }
    
    func test_saveDup_throws() throws {
        let result = [
            kSecAttrAccount as String: testEmail as Any,
            kSecValueData as String: enctryptedPass as Any
        ] as AnyObject
        kCMock.setReadResponse(result: result)
        do{
            _ = try kCManager.saveItem(account: testEmail, secretValue: testPassword)
            XCTAssert(false)
        }catch KeychainError.duplicateSave{
            XCTAssert(true)
        }catch {
            XCTAssert(false)
        }
    }
    
    func test_saveUpdatePass_success() throws {
        let oldPass = "oldPass".data(using: .utf8)
        let result = [
            kSecAttrAccount as String: testEmail as Any,
            kSecValueData as String: oldPass as Any
        ] as AnyObject
        kCMock.setReadResponse(result: result)
        XCTAssertNoThrow(
            try kCManager.saveItem(account: testEmail, secretValue: testPassword)
        )
    }
    
    func test_saveUpdateAccount_success() throws {
        let oldEmail = "oldEmail"
        let result = [
            kSecAttrAccount as String: oldEmail as Any,
            kSecValueData as String: enctryptedPass as Any
        ] as AnyObject
        kCMock.setReadResponse(result: result)
        XCTAssertNoThrow(
            try kCManager.saveItem(account: testEmail, secretValue: testPassword)
        )
    }
    
    func test_saveReadError_throws() throws {
        kCMock.setReadResponse(status: errSecInvalidAction, result: nil)
        XCTAssertThrowsError(
            try kCManager.saveItem(account: testEmail, secretValue: testPassword)
        )
    }

    override func tearDown() {
        kCMock = nil
        kCManager = nil
    }
}

