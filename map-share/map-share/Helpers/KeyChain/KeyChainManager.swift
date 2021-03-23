//
//  KeyChainItem.swift
//  map-share
//
//  Created by Pedram Shirmohammad on 2021-03-09.
//

import Foundation

// MARK: Types
enum KeychainError: Error, Equatable {
    case noItemFound
    case unexpectedItemData
    case unhandledError
    case duplicateSave
}

protocol KeyChainManagerProtocol {
    var label: String { get }
    var type: Int { get }
    var service: String { get }
    var keyChain: KeyChainProtocol { get }
    
    func readItem() throws -> (account: String, secretValue: String)
    func saveItem(account: String, secretValue: String) throws
    
    static var Passwrd: KeyChainManagerProtocol { get }
    static var Token: KeyChainManagerProtocol { get }
}


struct KeyChainManager : KeyChainManagerProtocol{
    
    //MARK: - Properties
    var label : String
    var type : Int
    var service : String
    var keyChain : KeyChainProtocol
    
    init(label: String, type: Int, service: String, keyChain: KeyChainProtocol = KeyChain()) {
        self.label = label
        self.type = type
        self.service = service
        self.keyChain = keyChain
    }
    
    //MARK: - Keychain Access
    func readItem() throws  -> (account: String, secretValue: String) {
        var query = keyChainQueryItem()
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        query[kSecReturnData as String] = kCFBooleanTrue
        
        let response = keyChain.read(query: query)
        guard response.status != errSecItemNotFound else { throw KeychainError.noItemFound }
        guard response.status == noErr else { throw KeychainError.unhandledError }
        
        guard let items = response.result as? Dictionary<String, Any>,
                let valueData = items[kSecValueData as String] as? Data,
                let value = String(data: valueData, encoding: String.Encoding.utf8),
                let account = items[kSecAttrAccount as String] as? String
        else { throw KeychainError.unexpectedItemData }
        
        return (account: account, secretValue: value)
    }
    
    func saveItem(account: String, secretValue: String) throws {
        let valueData = secretValue.data(using: String.Encoding.utf8)
        do {
            let user = try readItem()
            guard user.account != account ||
                    user.secretValue != secretValue
            else { throw KeychainError.duplicateSave }
            
            var attributesToUpdate = [String: AnyObject]()
            attributesToUpdate[kSecValueData as String] = valueData as AnyObject
            attributesToUpdate[kSecAttrAccount as String] = account as AnyObject
            
            let query = keyChainQueryItem()
            let status = keyChain.update(query: query, attributesToUpdate: attributesToUpdate)
            
            guard status == noErr else { throw KeychainError.unhandledError }
            
        } catch KeychainError.noItemFound {
            var query = keyChainQueryItem(account: account)
            query[kSecValueData as String] = valueData as AnyObject
            let status = keyChain.save(query: query)
            
            guard status == noErr else { throw KeychainError.unhandledError }
        }catch {
            // TODO: Update view on Exception
            throw error
        }
    }
    
    //MARK: - Conviniece
    private func keyChainQueryItem(account: String? = nil) -> [String: AnyObject]{
        var query = [String: AnyObject]()
        query[kSecClass as String] = kSecClassGenericPassword as AnyObject
        query[kSecAttrType as String] = type as AnyObject
        query[kSecAttrLabel as String] = label as AnyObject
        query[kSecAttrService as String] = service as AnyObject
        if let account = account{
            query[kSecAttrAccount as String] = account as AnyObject
        }
        return query
    }
}
    
extension KeyChainManager {
    static let Passwrd: KeyChainManagerProtocol = KeyChainManager(
        label: "Password",
        type: 11,
        service: "com.map-share.password"
    )
    static let Token: KeyChainManagerProtocol = KeyChainManager(
        label: "Token",
        type: 22,
        service: "com.map-share.token"
    )
}
