//
//  KeyChainItem.swift
//  map-share
//
//  Created by Pedram Shirmohammad on 2021-03-09.
//

import Foundation

struct KeyChainItem{
    //MARK: - Properties
    private let attrLabel : String
    private let attrType : Int
    private let attrService : String
    
    // MARK: Types
    enum KeychainError: Error {
        case noItemFound
        case unexpectedItemData
        case unhandledError
    }
    
    //MARK: - Keychain Access
    func readItem() throws  -> (account: String, secretValue: String) {
        var query = keyChainQueryItem()
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        query[kSecReturnData as String] = kCFBooleanTrue
        
        var result : AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status != errSecItemNotFound else { throw KeychainError.noItemFound }
        guard status == noErr else { throw KeychainError.unhandledError }
        
        guard let items = result as? Dictionary<String, Any>,
                let valueData = items[kSecValueData as String] as? Data,
                let value = String(data: valueData, encoding: String.Encoding.utf8),
                let account = items[kSecAttrAccount as String] as? String
        else { throw KeychainError.unexpectedItemData }
        
        return (account: account, secretValue: value)
    }
    
    func saveItem(secretValue: String, account: String) throws {
        let valueData = secretValue.data(using: String.Encoding.utf8)
        do {
            try _ = readItem()
            
            var attributesToUpdate = [String: AnyObject?]()
            attributesToUpdate[kSecValueData as String] = valueData as AnyObject?
            attributesToUpdate[kSecAttrAccount as String] = account as AnyObject?
            
            let query = keyChainQueryItem(account: account)
            let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
            
            guard status == noErr else { throw KeychainError.unhandledError }
            
        } catch KeychainError.noItemFound {
            var query = keyChainQueryItem(account: account)
            query[kSecValueData as String] = valueData as AnyObject
            let status = SecItemAdd(query as CFDictionary, nil)
            
            guard status == noErr else { throw KeychainError.unhandledError }
        }catch {
            // TODO: Update view on Exception
            print("Exception needs to be handled")
        }
    }
    
    //MARK: - Conviniece
    private func keyChainQueryItem(account: String? = nil) -> [String: AnyObject?]{
        var query = [String: AnyObject]()
        query[kSecClass as String] = kSecClassGenericPassword
        query[kSecAttrType as String] = attrType as AnyObject?
        query[kSecAttrLabel as String] = attrLabel as AnyObject?
        query[kSecAttrService as String] = attrService as AnyObject?
        if let account = account{
            query[kSecAttrAccount as String] = account as AnyObject?
        }
        return query
    }
}
    
extension KeyChainItem {
    static let Passwrd = KeyChainItem(
        attrLabel: "Password",
        attrType: 11,
        attrService: "com.map-share.password"
    )
    static let Token = KeyChainItem(
        attrLabel: "Token",
        attrType: 22,
        attrService: "com.map-share.token"
    )
}
