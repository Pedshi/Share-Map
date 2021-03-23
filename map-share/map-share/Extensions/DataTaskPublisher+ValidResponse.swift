//
//  DataTaskPublisher+ValidResponse.swift
//  map-share
//
//  Created by Pedram Shirmohammad on 2021-03-23.
//

import Foundation
import Combine

enum RequestError: Error {
    case forbidden
    case badReequest
    case unAuthorized
    case notFound
    case invalidResponse
    case serverError
    case unhandledError
}

extension URLSession.DataTaskPublisher {
    func validateResponse() -> Publishers.TryMap<URLSession.DataTaskPublisher,(data:Data, response: HTTPURLResponse) >{
        self.tryMap { (data: Data, response: URLResponse) -> (data:Data, response: HTTPURLResponse)  in
            guard let httpResponse = response as? HTTPURLResponse else{ throw RequestError.invalidResponse }
            switch httpResponse.statusCode{
            case 400: throw RequestError.badReequest
            case 401: throw RequestError.unAuthorized
            case 403: throw RequestError.forbidden
            case 404: throw RequestError.notFound
            case let x where x >= 500: throw RequestError.serverError
            default: break
            }
            guard 200..<300 ~= httpResponse.statusCode else { throw RequestError.unhandledError }
            return (data: data, response: httpResponse )
        }
    }
}
