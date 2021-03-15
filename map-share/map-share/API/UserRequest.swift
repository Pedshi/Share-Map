//
//  UserRequest.swift
//  map-share
//
//  Created by Pedram Shirmohammad on 2021-03-09.
//

import Foundation
import Combine

class UserRequest {
    
    //MARK: - Properties
    //Save url some where else
    private let baseUrl = "http://localhost:3001/api/anvandare"
    private var loginUrl : URL { URL(string: baseUrl + "/loggain")! }
    private var validateTokenURL : URL { URL(string: baseUrl + "/token")! }
    
    //MARK: - Requests
    func loginRequest(email: String, password: String) {
        let jsonData = requestBody(email: email, password: password)
        let urlReq = urlReqPostBuilder(url: loginUrl)

        URLSession.shared.uploadTask(with: urlReq, from: jsonData){ [weak self] data, response, error in
            //CLEAN UP: START
            if let e = error {
                print("Error: \(e)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Could not convert Response to HTTPURLResponse")
                return
            }
            guard httpResponse.statusCode == 200 else{
                print("Unauthorized Login Requests")
                return
            }
            //CLEAN UP: END
            //Maybe should switch to main thread
            //Should also save account and password for update token
            if let cookie = httpResponse.value(forHTTPHeaderField: "Set-Cookie") {
                guard let token = self?.trimCookie(cookie: cookie) else{ return }
                try? KeyChainItem.Token.saveItem(secretValue: token, account: email.lowercased())
                print("Logged in")
            }

        }.resume()
        
    }
    
    func validateTokenRequest(email: String, token: String) {
        let jsonData = requestBody(email: email)
        var urlReq = urlReqPostBuilder(url: validateTokenURL)
        urlReq.setValue("_t=" + token, forHTTPHeaderField: "Cookie")
        urlReq.httpShouldHandleCookies = true
        //urlReq.httpBody = jsonData
        
        
        URLSession.shared.uploadTask(with: urlReq, from: jsonData){ data, response, error in
            //CLEAN UP: START
            if let e = error {
                print("Error: \(e)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Could not convert Response to HTTPURLResponse")
                return
            }
            guard httpResponse.statusCode == 200 else{
                // Should try to login with KeyChain credentials and if not able go to login page
                print("Unauthorized Token Request")
                return
            }
            //CLEAN UP: END
            print("Valid Token!")
        }.resume()
        
    }
    
    //MARK: - Conviniece
    private func urlReqPostBuilder(url: URL) -> URLRequest {
        var urlReq = URLRequest(url: url)
        urlReq.httpMethod = "POST"
        urlReq.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return urlReq
    }
    
    private func requestBody(email: String, password: String? = nil) -> Data{
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
    private func trimCookie(cookie: String) -> String{
        var from = cookie.firstIndex(of: "=")!
        from = cookie.index(from, offsetBy: 1)
        var trimmed = cookie.suffix(from: from)
        let to = trimmed.firstIndex(of: ";")!
        trimmed = trimmed.prefix(upTo: to)
        return String(trimmed)
    }
    
    func valToken(email:String, token:String)->(req: URLRequest, json: Data){
        let jsonData = requestBody(email: email)
        var urlReq = urlReqPostBuilder(url: validateTokenURL)
        urlReq.setValue("_t=" + token, forHTTPHeaderField: "Cookie")
        urlReq.httpShouldHandleCookies = true
        return (req: urlReq, json: jsonData)
    }
    
    
}
