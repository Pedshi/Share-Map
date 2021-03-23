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
    
    var body : some View {
        Map(coordinateRegion: $coor, annotationItems: markers) { marker in
            marker.location
        }
        .ignoresSafeArea()
    }
}


struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(viewModel: MapViewModel())
    }
}
