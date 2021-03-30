//
//  MapWithMarkers.swift
//  map-share
//
//  Created by Pedram Shirmohammad on 2021-03-30.
//

import SwiftUI
import MapKit
import CoreLocation

struct MapWithMarkers: View {
    var markers : [Place]
    
    @State private var showDetail = false
    @State private var selectedPlace : Place?
    
    @EnvironmentObject var viewModel : MapViewModel
    @State private var tracking : MapUserTrackingMode = .none
    @State private var region = MKCoordinateRegion(center: MapWithMarkers.defaultLocation, span: MapWithMarkers.defaultSpan)
    
    @ObservedObject private var location = LocationManager()
    @State private var manager = CLLocationManager()
    
    var body : some View {
        GeometryReader { geometry in
            ZStack(alignment: .top){
                Map(
                    coordinateRegion: $region,
                    interactionModes: .all,
                    showsUserLocation: true,
                    userTrackingMode: $tracking,
                    annotationItems: markers){ marker in
                    
                    MapAnnotation(coordinate: marker.coord){
                        Image(systemName: "mappin")
                            .font(.title)
                            .foregroundColor(.red)
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: AnimationDurr.short.rawValue) ){
                                    showDetail = true
                                    selectedPlace = marker
                                }
                            }
                    }
                }
                    .zIndex(1)
                HalfModal(
                    visible: $showDetail,
                    place: selectedPlace,
                    offset: geometry.size.height
                )
                    .zIndex(2)
                    
            }
        }
        .onAppear{
            manager.delegate = location
            manager.requestAlwaysAuthorization()
        }
        .onReceive(location.$lastKnownLocation){ lastLocation in
            guard let userLocation = lastLocation else { return }
            withAnimation(.easeIn(duration: AnimationDurr.short.rawValue)){
                region.center = userLocation
                region.span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            }
        }
        .ignoresSafeArea()
    }
    
    static let defaultLocation = CLLocationCoordinate2D(
        latitude: 59.2123744651292,
        longitude: 18.074693826274057
    )
    static let defaultSpan = MKCoordinateSpan(latitudeDelta: 15.0, longitudeDelta: 15.0)
}
