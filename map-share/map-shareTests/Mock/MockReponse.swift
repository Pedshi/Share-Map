//
//  MockReponse.swift
//  map-shareTests
//
//  Created by Pedram Shirmohammad on 2021-03-18.
//

import Foundation

enum MockResponse {

    static func mock(success: Bool = true, headers: [String:String]? = nil ,data: Data? = nil) throws -> (HTTPURLResponse, Data?){
        let resp = HTTPURLResponse(
            url: URL(string: "test.example.com")!,
            statusCode: success ? 200 : 400,
            httpVersion: nil,
            headerFields: headers
        )!
        return (resp, data)
    }
}
