//
//  MockKeyChain.swift
//  map-shareTests
//
//  Created by Pedram Shirmohammad on 2021-03-23.
//

import Foundation
@testable import map_share

class MockKeyChain: KeyChainProtocol {
    var responseStatus = OSStatus(0)
    var responseRead = OSStatus(0)
    var result = [
        kSecValueData as String: "test",
        kSecAttrAccount as String: "email"
    ] as AnyObject?
    
    func save(query: [String : AnyObject]) -> OSStatus {
        return responseStatus
    }
    
    func delete(query: [String : AnyObject]) -> OSStatus {
        return responseStatus
    }
    
    func update(query: [String : AnyObject], attributesToUpdate toUpdate: [String : AnyObject]) -> OSStatus {
        return responseStatus
    }
    
    func read(query: [String : AnyObject]) -> KeyChainResult {
        return KeyChainResult(status: responseRead, result: result)
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
        return (account: savedAccount, secretValue: savedSecretValue)
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
