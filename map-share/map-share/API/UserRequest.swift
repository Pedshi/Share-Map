//
//  UserRequest.swift
//  map-share
//
//  Created by Pedram Shirmohammad on 2021-03-09.
//
// First build a mock test for this case
// Then refactor this code into a better one

import Foundation
import Combine

enum API{}

extension API {
    enum User {
        static func loginRequest(email: String,
                                 password: String,
                                 session: URLSession = .shared,
                                 KCManager: KeyChainManagerProtocol.Type = KeyChainManager.self) -> AnyPublisher<Void, Error>{
            let jsonData = UserRequest.requestBody(email: email, password: password)
            let request = Endpoints.login.build(authData: nil, bodyData: jsonData)!
            
            return session.dataTaskPublisher(for: request)
                .validateResponse()
                .map{ (data, response) in
                    if let cookie = response.value(forHTTPHeaderField: "Set-Cookie") {
                        let token = UserRequest.trimCookie(cookie: cookie)
                        try? KCManager.Token.saveItem(account: email.lowercased(), secretValue: token)
                    }
                    try? KCManager.Passwrd.saveItem(account: email.lowercased(), secretValue: password)
                }
                .eraseToAnyPublisher()
        }
        
        static func registerRequest(email: String,
                                    password: String,
                                    session: URLSession = .shared,
                                    KCManager: KeyChainManagerProtocol.Type = KeyChainManager.self) -> AnyPublisher<Void, Error>{
            let jsonData = UserRequest.requestBody(email: email, password: password)
            let request = Endpoints.register.build(authData: nil, bodyData: jsonData)!
            
            return session.dataTaskPublisher(for: request)
                .validateResponse()
                .map{ _ in }
                .eraseToAnyPublisher()
        }
        
        static func validateTokenRequest(email: String, token: String, session: URLSession = .shared) -> AnyPublisher<Void, Error>{
            let jsonData = UserRequest.requestBody(email: email)
            let request = Endpoints.validateToken.build(authData: token, bodyData: jsonData)!

            return session.dataTaskPublisher(for: request)
                .validateResponse()
                .map{ _ in }
                .eraseToAnyPublisher()
        }
    }
}

enum UserRequest {
    static func requestBody(email: String, password: String? = nil) -> Data{
        var rawBody = [String:String]()
        rawBody["email"] = email.lowercased()
        if let password = password{
            rawBody["password"] = password
        }
        //FIX else clause
        guard let jsonData = try? JSONSerialization.data(withJSONObject: rawBody, options: []) else{ return Data() }
        
        return jsonData
    }
    
    //MARK: - Temporary Helpers
    static public func trimCookie(cookie: String) -> String{
        var from = cookie.firstIndex(of: "=")!
        from = cookie.index(from, offsetBy: 1)
        var trimmed = cookie.suffix(from: from)
        let to = trimmed.firstIndex(of: ";")!
        trimmed = trimmed.prefix(upTo: to)
        return String(trimmed)
    }
}
