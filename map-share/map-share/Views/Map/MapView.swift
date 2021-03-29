//
//  MapView.swift
//  map-share
//
//  Created by Pedram Shirmohammad on 2021-03-18.
//

import SwiftUI
import MapKit

struct MapView: View {
    @ObservedObject var viewModel : MapViewModel
    
    var body: some View {
        content()
            .ignoresSafeArea()
    }
    
    @ViewBuilder
    func content() -> some View{
        switch viewModel.state {
        case .loading:
            spinner
        case let .idle(places):
            MapWithMarkers(markers: places)
        case .loadingFailed:
            Text("Failed to load locations")
        }
    }
    
    private var spinner: some View {
        ProgressView()
    }
}

struct MapWithMarkers: View {
    @State private var coor = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 59.30751800824026, longitude: 18.07836529845038),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    var markers : [Place]
    
    @State private var showDetail = false
    @State private var selectedPlace = Place(
        id: "1",
        latitude: 0,
        longitude: 0,
        name: "-",
        address: "-",
        openingHours: ["mon" : "09:00-21:00"]
    )
    
    var body : some View {
        GeometryReader { geometry in
            ZStack(alignment: .top){
                Map(coordinateRegion: $coor, annotationItems: markers) { marker in
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
                }.zIndex(1)
                HalfModal(
                    visible: $showDetail,
                    place: selectedPlace,
                    offset: geometry.size.height
                )
                    .zIndex(2)
                    
            }
        }
        .ignoresSafeArea()
    }
}







struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(viewModel: MapViewModel())
    }
}



