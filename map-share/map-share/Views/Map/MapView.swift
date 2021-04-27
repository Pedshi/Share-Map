//
//  MapView.swift
//  map-share
//
//  Created by Pedram Shirmohammad on 2021-03-18.
//

import SwiftUI

struct MapView: View {
    @ObservedObject var viewModel : MapViewModel
    
    var body: some View {
        content()
            .ignoresSafeArea()
    }
    
    @ViewBuilder
    func content() -> some View{
        switch viewModel.state {
        case .loadingPlaces:
            spinner
        case let .idle(places):
            MapWithMarkers(markers: places)
                .environmentObject(viewModel)
        case .loadingFailed:
            loadingFailed
        }
    }
    
    private var spinner: some View {
        ProgressView()
    }
    
    private var loadingFailed: some View {
        VStack{
            Image(systemName: "wifi.slash")
                .foregroundColor(.secondary)
                .imageScale(.large)
            Text("Failed to fetch saved locations.")
                .padding(Space.times2.rawValue)
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(viewModel: MapViewModel())
    }
}



