//
//  Mock.swift
//  map-shareTests
//
//  Created by Pedram Shirmohammad on 2021-03-18.
//

import Foundation
import XCTest

class MockSession: URLProtocol {
    static var response: (HTTPURLResponse, Data?)?
    
    override class func canInit(with request: URLRequest) -> Bool {
        true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func stopLoading() {
        
    }
    
    override func startLoading() {
        
        do{
            let (response, data) = try XCTUnwrap(MockSession.response)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            if let data = data {
                client?.urlProtocol(self, didLoad: data)
            }
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
        
    }
}
