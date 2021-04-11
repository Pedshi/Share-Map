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
    
    //Default map settings
    @EnvironmentObject var viewModel : MapViewModel
    @State private var tracking : MapUserTrackingMode = .none
    @State private var region = MKCoordinateRegion(center: MapWithMarkers.defaultLocation, span: MapWithMarkers.defaultSpan)
    
    //MARK: - Variables
    @State private var markers : [Place]
    @State private var showDetail = false
    @ObservedObject private var location = LocationManager()
    @State private var manager = CLLocationManager()
    @State var chosenIndex: Int?
    
    init(markers: [Place]){
        self._markers = State(wrappedValue: markers)
    }
    
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
                        Image(uiImage: UIImage(named: pin(for: marker.category), in: nil, with: calculatorSymbolConfig)!)
                            .frame(width: minButtonSize, height: minButtonSize, alignment: .topTrailing)
                            .onTapGesture {
                                showDetail = true
                                chosenIndex = markers.firstIndex(where: {$0.id == marker.id })
                                markers[chosenIndex!].select()
                            }
                            .scaleEffect( marker.isSelected ? zoomScale : 1)
                            .animation(.easeInOut(duration: AnimationDurr.short.rawValue))
                    }
                }
                .zIndex(1)
                if markers.count > 0, let chosenIndex = chosenIndex {
                    HalfModal(
                        visible: $showDetail,
                        place:  $markers[chosenIndex],
                        offset: geometry.size.height
                    )
                    .zIndex(2)
                }
            }
        }
        .onAppear{
            manager.delegate = location
            manager.requestAlwaysAuthorization()
        }
        .onReceive(location.$lastKnownLocation){ lastLocation in
            guard let userLocation = lastLocation else { return }
            region.center = userLocation
            region.span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        }
        .ignoresSafeArea()
    }
    
    func pin(for categories: [Int]) -> String {
        guard 0 < categories.count else { return "defaultpin" }
        switch categories[0] {
        case 1:
            return "drinkpin"
        case 2:
            return "cafepin"
        case 3:
            return "cutlerypin"
        case 4:
            return "shoppin"
        default:
            return "defaultpin"
        }
    }
    
    //MARK: - static local variables
    static let defaultLocation = CLLocationCoordinate2D(
        latitude: 59.2123744651292,
        longitude: 18.074693826274057
    )
    static let defaultSpan = MKCoordinateSpan(latitudeDelta: 15.0, longitudeDelta: 15.0)
    let calculatorSymbolConfig = UIImage.SymbolConfiguration(pointSize: 24.0, weight: .regular, scale: .large)
    let zoomScale: CGFloat = 1.3
    let minButtonSize: CGFloat = 44
    
}

