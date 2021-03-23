//
//  KeyChain.swift
//  map-share
//
//  Created by Pedram Shirmohammad on 2021-03-23.
//

import Foundation

public protocol KeyChainProtocol {
    func save(query: [String: AnyObject]) -> OSStatus
    func delete(query: [String: AnyObject]) -> OSStatus
    func update(query: [String: AnyObject], attributesToUpdate toUpdate: [String: AnyObject]) -> OSStatus
    func read(query: [String: AnyObject]) -> KeyChainResult
}

public struct KeyChainResult {
    var status : OSStatus
    var result : AnyObject?
}

struct KeyChain: KeyChainProtocol{
    
    func save(query: [String : AnyObject]) -> OSStatus {
        return SecItemAdd(query as CFDictionary, nil)
    }
    
    func delete(query: [String: AnyObject]) -> OSStatus {
        return SecItemDelete(query as NSDictionary)
    }
    
    func read(query: [String: AnyObject]) -> KeyChainResult {
        var result : AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        return KeyChainResult(status: status, result: result)
    }
    
    func update(query: [String: AnyObject], attributesToUpdate update: [String : AnyObject]) -> OSStatus {
        return SecItemUpdate(query as CFDictionary, update as CFDictionary)
    }
}
