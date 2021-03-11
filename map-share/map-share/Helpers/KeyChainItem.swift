//
//  KeyChainItem.swift
//  map-share
//
//  Created by Pedram Shirmohammad on 2021-03-09.
//

import Foundation

struct KeyChainItem{
    
    // MARK: Types
    enum KeychainError: Error {
        case noItemFound
        case unexpectedItemData
        case unhandledError
    }
    
    //MARK: - Properties
    private let tokenLabel = "Token"
    private let tokenType = 22
    
    //MARK: - Initialization
    
    //MARK: - Keychain Access
    func readItem() throws  -> (account: String, token: String) {
        var query = keyChainQuery()
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        query[kSecReturnData as String] = kCFBooleanTrue
        
        var result : AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status != errSecItemNotFound else { throw KeychainError.noItemFound }
        guard status == noErr else { throw KeychainError.unhandledError }
        
        guard let items = result as? Dictionary<String, Any>,
                let tokenData = items[kSecValueData as String] as? Data,
                let token = String(data: tokenData, encoding: String.Encoding.utf8),
                let account = items[kSecAttrAccount as String] as? String
        else { throw KeychainError.unexpectedItemData }
        
        return (account: account, token: token)
    }
    
    func saveItem(token: String, account: String) throws {
        let tokenData = token.data(using: String.Encoding.utf8)
        do {
            try _ = readItem()
            
            var attributesToUpdate = [String: AnyObject?]()
            attributesToUpdate[kSecValueData as String] = tokenData as AnyObject?
            attributesToUpdate[kSecAttrAccount as String] = account as AnyObject?
            
            let query = keyChainQuery(account: account)
            let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
            
            guard status == noErr else { throw KeychainError.unhandledError }
            
        } catch KeychainError.noItemFound {
            var query = keyChainQuery(account: account)
            query[kSecValueData as String] = tokenData as AnyObject
            let status = SecItemAdd(query as CFDictionary, nil)
            
            guard status == noErr else { throw KeychainError.unhandledError }
        }catch {
            // TODO: Update view on Exception
            print("Exception needs to be handled")
        }
    }
    
    //MARK: - Conviniece
    private func keyChainQuery(account: String? = nil) -> [String: AnyObject?]{
        var query = [String: AnyObject]()
        query[kSecClass as String] = kSecClassGenericPassword
        query[kSecAttrType as String] = tokenType as AnyObject?
        query[kSecAttrLabel as String] = tokenLabel as AnyObject?
        if let account = account{
            query[kSecAttrAccount as String] = account as AnyObject?
        }
        return query
    }
}
