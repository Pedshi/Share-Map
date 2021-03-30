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
        case .loading:
            spinner
        case let .idle(places):
            MapWithMarkers(markers: places)
                .environmentObject(viewModel)
        case .loadingFailed:
            Text("Failed to load locations")
        }
    }
    
    private var spinner: some View {
        ProgressView()
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(viewModel: MapViewModel())
    }
}



