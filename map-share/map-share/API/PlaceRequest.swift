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
        static func fetchPlaces(session: URLSession = .shared) -> AnyPublisher<Data, Error>{
            let request = Endpoints.fetchPlaces.build(authData: nil, bodyData: nil)!
            return session.dataTaskPublisher(for: request)
                    .validateResponse()
                    .map{ $0.data }
                    .eraseToAnyPublisher()
        }
    }
}


struct Place : Identifiable, Codable {
    var id : String
    var latitude : Double
    var longitude : Double
    var name : String
    var address : String
    
    var location : MapMarker {
        MapMarker(coordinate: CLLocationCoordinate2D(
            latitude: self.latitude,
            longitude: self.longitude
        ))
    }
}
