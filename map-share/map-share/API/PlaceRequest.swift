//
//  Place.swift
//  map-share
//
//  Created by Pedram Shirmohammad on 2021-03-18.
//

import Foundation
import Combine
import SwiftUI
import MapKit

extension API{
    enum Place {
        static func fetchPlacesRequest(token: String, session: URLSession = .shared) -> AnyPublisher<Data, Error>{
            let request = Endpoints.fetchPlaces.build(authData: token, bodyData: nil)!
            return session.dataTaskPublisher(for: request)
                    .validateResponse()
                    .map{ $0.data }
                    .eraseToAnyPublisher()
        }
    }
}


struct Place : Identifiable, Codable, Equatable {
    var id : String
    var latitude : Double
    var longitude : Double
    var name : String
    var address : String
    var openingHours : [String: String]
    var category : Int
    
    var isSelected: Bool = false
    
    mutating func select(){
        isSelected = true
    }
    
    mutating func deselect(){
        isSelected = false
    }
    
    var coord : CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
    
    enum CodingKeys: String, CodingKey {
        case latitude, longitude, name, address, openingHours, category
        case id = "_id"
    }
}
