//
//  HomeViewModel.swift
//  map-share
//
//  Created by Pedram Shirmohammad on 2021-03-09.
//

import Foundation
import Combine

class HomeViewModel : ObservableObject{
    @Published private(set) var state = "TO BE SET"
    
}



//    init(){
//        isTokenValid()
//    }
//
//    func isTokenValid(){
//        // Se om token finns
//        do {
//            //let user = try KeyChainItem().readItem()
//            let resp = UserRequest().valToken(email: "pedram.shir@hotmail.com", token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2MDE3ZmVhZGEyMzA4ZDgwYTZjMDZiOWQiLCJpYXQiOjE2MTUzMjM0ODAsImV4cCI6MTYxNTMyNzA4MH0.PJxbP5jPjDZrYTsknT8NEZtv2sbgyPPvYX3EjQVd9eo")
//
//
//            URLSession.shared.uploadTask(with: resp.req, from: resp.json){[weak self] data, response, error in
//                //CLEAN UP: START
//                if let e = error {
//                    print("Error: \(e)")
//                    return
//                }
//                guard let httpResponse = response as? HTTPURLResponse else {
//                    print("Could not convert Response to HTTPURLResponse")
//                    return
//                }
//                guard httpResponse.statusCode == 200 else{
//                    // Should try to login with KeyChain credentials and if not able go to login page
//                    print("Unauthorized Token Request")
//                    return
//                }
//                //CLEAN UP: END
//                print("Valid Token!")
//                DispatchQueue.main.async {
//                    self?.loggedIn = true
//                }
//            }.resume()
//
//
//
//        } catch KeyChainItem.KeychainError.noItemFound {
//            //Send to Login Page
//        }catch {
//            print("Other Errors")
//        }
//    }
//
//    private func trimCookie(cookie: String) -> String{
//        var from = cookie.firstIndex(of: "=")!
//        from = cookie.index(from, offsetBy: 1)
//        var trimmed = cookie.suffix(from: from)
//        let to = trimmed.firstIndex(of: ";")!
//        trimmed = trimmed.prefix(upTo: to)
//        return String(trimmed)
//    }
