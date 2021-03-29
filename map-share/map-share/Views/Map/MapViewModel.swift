//
//  MapView.swift
//  map-share
//
//  Created by Pedram Shirmohammad on 2021-03-18.
//

import Foundation
import Combine

class MapViewModel: ObservableObject {
    @Published var state : State = .loading
 
    private var bag = Set<AnyCancellable>()
    
    private let input = PassthroughSubject<Event, Never>()
    
    init() {
        Publishers.system(
            initial: state,
            reduce: Self.reduce,
            scheduler: RunLoop.main,
            feedbacks: [
                Self.whenLoading(),
                Self.input(input: input.eraseToAnyPublisher())
            ]
        )
        .assign(to: \.state, on: self)
        .store(in: &bag)
    }
    
    deinit {
        bag.removeAll()
    }
    
    func send(event: Event){
        input.send(event)
    }
}

extension MapViewModel {
    enum State {
        case loading
        case idle([Place])
        case loadingFailed
    }
    
    enum Event {
        case onLoading
        case onLoadingSuccess([Place])
        case onLoadingFailed(Error)
    }
    
    static func reduce(state: State, event: Event) -> State {
        switch state {
        case .loading:
            return reduceLoading(state: state, event: event)
        case .idle:
            return state
        case .loadingFailed:
            return state
        }
    }
 
    static func reduceLoading(state: State, event: Event) -> State {
        switch event {
        case let .onLoadingSuccess(placeList):
            return .idle(placeList)
        case .onLoadingFailed:
            return .loadingFailed
        default:
            return state
        }
    }
    
    static func whenLoading() -> Feedback<State, Event> {
        Feedback { (state: State) -> AnyPublisher<Event, Never>  in
            guard case .loading = state else { return Empty().eraseToAnyPublisher() }
            
            return API.Place.fetchPlaces()
                .decode(type: [Place].self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .map(Event.onLoadingSuccess)
                .catch{ Just(Event.onLoadingFailed($0)) }
                .eraseToAnyPublisher()
        }
    }
    
    static func input(input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
        Feedback { _ in input }
    }
    
}
