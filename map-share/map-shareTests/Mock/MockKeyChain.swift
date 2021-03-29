//
//  MockKeyChain.swift
//  map-shareTests
//
//  Created by Pedram Shirmohammad on 2021-03-23.
//

import Foundation
@testable import map_share

class MockKeyChain: KeyChainProtocol {

    var readStatus = OSStatus(0)
    var readResult = [
        kSecValueData as String: "test",
        kSecAttrAccount as String: "email"
    ] as AnyObject?
    
    
    var saveStatus = noErr
    var updateStatus = noErr
    var deleteStatus = noErr
    
    
    var readQuery = [[String: AnyObject]?]()
    var updateQuery = [[String: AnyObject]?]()
    var deleteQuery = [[String: AnyObject]?]()
    var saveQuery = [[String: AnyObject]?]()
    
    
    func setReadResponse(status: OSStatus = noErr, result: AnyObject?){
        readStatus = status
        readResult = result
    }
    
    func save(query: [String : AnyObject]) -> OSStatus {
        saveQuery.append(query)
        return saveStatus
    }
    
    func delete(query: [String : AnyObject]) -> OSStatus {
        deleteQuery.append(query)
        return deleteStatus
    }
    
    func update(query: [String : AnyObject], attributesToUpdate toUpdate: [String : AnyObject]) -> OSStatus {
        updateQuery.append(query)
        return updateStatus
    }
    
    func read(query: [String : AnyObject]) -> KeyChainResult {
        readQuery.append(query)
        return KeyChainResult(status: readStatus, result: readResult)
    }
}

class MockKeyChainManager: KeyChainManagerProtocol {
    var label: String
    var type: Int
    var service: String
    var keyChain: KeyChainProtocol
    
    var savedAccount = ""
    var savedSecretValue = ""
    
    init(label: String, type: Int, service: String) {
        self.label = label
        self.type = type
        self.service = service
        self.keyChain = MockKeyChain()
    }
    
    func readItem() throws -> (account: String, secretValue: String) {
        (account: savedAccount, secretValue: savedSecretValue)
    }
    
    func saveItem(account: String, secretValue: String) throws {
        savedAccount = account
        savedSecretValue = secretValue
    }
    
    static var Passwrd: KeyChainManagerProtocol = MockKeyChainManager(
        label: "pass",
        type: 1,
        service: "passService")
    
    static var Token: KeyChainManagerProtocol = MockKeyChainManager(
        label: "token",
        type: 2,
        service: "Token")
}
