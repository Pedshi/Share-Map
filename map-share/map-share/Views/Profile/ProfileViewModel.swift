//
//  ProfileViewModel.swift
//  map-share
//
//  Created by Pedram Shirmohammad on 2021-04-24.
//

import Foundation
import Combine

class ProfileViewModel: ObservableObject {
    @Published var state : State = .loadingProfile

    private var bag = Set<AnyCancellable>()
    
    private let input = PassthroughSubject<Event, Never>()
    
    init() {
        Publishers.system(
            initial: state,
            reduce: Self.reduce,
            scheduler: RunLoop.main,
            feedbacks: [
                Self.whenLoadingProfile(),
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

extension ProfileViewModel{
    enum State {
        case loadingProfile
        case idle([Place], String)
        case loadingFailed
    }
    
    enum Event {
        case onLoadingSuccess([Place], String)
        case onLoadingFailed(Error)
    }
    
    static func reduce(state: State, event: Event) -> State {
        switch state {
        case .loadingProfile:
            return reduceLoading(state: state, event: event)
        case .idle:
            return state
        case .loadingFailed:
            return state
        }
    }
    
    static func reduceLoading(state: State, event: Event) -> State {
        switch event {
        case let .onLoadingSuccess(placeList, email):
            return .idle(placeList, email)
        case .onLoadingFailed:
            return .loadingFailed
        }
    }
    
    static func whenLoadingProfile() -> Feedback<State, Event> {
        Feedback { (state: State) -> AnyPublisher<Event, Never>  in
            guard case .loadingProfile = state else { return Empty().eraseToAnyPublisher() }
            do{
                let user = try KeyChainManager.Token.readItem()
                return API.Place.fetchPlacesRequest(token: user.secretValue)
                    .decode(type: [Place].self, decoder: JSONDecoder())
                    .receive(on: DispatchQueue.main)
                    .map{ places in Event.onLoadingSuccess(places, user.account) }
                    .catch{ Just(Event.onLoadingFailed($0)) }
                    .eraseToAnyPublisher()
            }catch {
                return Just(Event.onLoadingFailed(error)).eraseToAnyPublisher()
            }
        }
    }
    
    static func input(input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
        Feedback { _ in input }
    }
}
