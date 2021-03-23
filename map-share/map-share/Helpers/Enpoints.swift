//
//  UserEnpoints.swift
//  map-share
//
//  Created by Pedram Shirmohammad on 2021-03-18.
//

import Foundation
import Combine

struct Endpoints<Kind: TypeOfRequest, Method: MethodForRequest> {
    var path : String
    var queryItems: [URLQueryItem]?
    
    private var base : URLComponents {
        var component = URLComponents()
        #if DEBUG
            component.scheme = "http"
            component.host = "localhost"
            component.port = 3001
        #else
            component.scheme = "https"
            component.host = "salty-chamber-16325.herokuapp.com"
        #endif
        return component
    }

    func build(authData: Kind.RequestData, bodyData: Method.BodyData) -> URLRequest? {
        var component = base
        component.path = "/api/" + path
        component.queryItems = queryItems
        
        guard let url = component.url else { return nil }
        
        var request = URLRequest(url: url)
        Kind.prepare(request: &request, data: authData)
        Method.setBody(request: &request, data: bodyData)
        return request
    }
}


protocol TypeOfRequest{
    associatedtype RequestData
    static func prepare(request: inout URLRequest, data: RequestData)
}

enum RequestType {
    enum Public: TypeOfRequest{
        static func prepare(request: inout URLRequest, data: Void?) {
            request.cachePolicy = .reloadIgnoringCacheData
        }
    }

    enum Private: TypeOfRequest{
        static func prepare(request: inout URLRequest, data: String) {
            request.httpShouldHandleCookies = true
            request.setValue("_t=" + data, forHTTPHeaderField: "Cookie")
        }
    }
}

protocol MethodForRequest {
    associatedtype BodyData
    static func setBody(request: inout URLRequest, data: BodyData)
}

enum RequestMethod {
    enum Get: MethodForRequest {
        static func setBody(request: inout URLRequest, data: Void?) {
            request.httpMethod = "GET"
        }
    }
    
    enum Post: MethodForRequest {
        static func setBody(request: inout URLRequest, data: Data?) {
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = data
        }
    }
}


extension Endpoints where Kind == RequestType.Public,
                          Method == RequestMethod.Get{
    static var fetchPlaces = Endpoints(path: "place", queryItems: [])
}

extension Endpoints where Kind == RequestType.Public,
                          Method == RequestMethod.Post {
    static var login = Endpoints(path: "anvandare/loggain", queryItems: [])
}

extension Endpoints where Kind == RequestType.Private,
                          Method == RequestMethod.Post {
    static var validateToken = Endpoints(path: "anvandare/token", queryItems: [])
}
