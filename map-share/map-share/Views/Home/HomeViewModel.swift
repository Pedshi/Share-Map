//
//  HomeViewModel.swift
//  map-share
//
//  Created by Pedram Shirmohammad on 2021-03-09.
//

import Foundation
import Combine

class HomeViewModel : ObservableObject{
    @Published private(set) var state : State
    
    private var bag = Set<AnyCancellable>()
    
    private var input = PassthroughSubject<Event, Never>()
    
    init() {
        self.state = .idle
        Publishers.system(
            initial: state,
            reduce: Self.reduce,
            scheduler: RunLoop.main,
            feedbacks: [
                Self.whenLoading(),
                Self.userInput(input: input.eraseToAnyPublisher())
            ]
        )
        .assign(to: \.state, on: self)
        .store(in: &bag)
    }
    
    
    deinit {
        bag.removeAll();
    }
    
    func send(event: Event){
        input.send(event)
    }
    
}


extension HomeViewModel{
    enum State {
        case idle
        case loading
        case loadingFailed
        case goToLogin
    }
    
    enum Event {
        case onLoading
        case onLoadingSuccess
        case onLoadingFail(Error)
    }
    
    static func reduce(state: State, event: Event) -> State{
        print("In : HomeViewModel")
        print("current State : \(state)")
        print("current Event : \(event)")
        print("-------------------------------------")
        switch state {
        case .idle:
            return reduceIdle(state: state, event: event)
        case .loading:
            return reduceLoading(state: state, event: event)
        case .loadingFailed:
            return reduceLoadingFailed(state: state, event: event)
        case .goToLogin:
            return state
        }
    }
    
    static func reduceIdle(state: State, event: Event) -> State{
        return state
    }
    
    static func reduceLoading(state: State, event: Event) -> State{
        switch event {
        case .onLoadingSuccess:
            return .idle
        case .onLoadingFail:
            return .loadingFailed
        default:
            return state
        }
    }
    
    enum ReqError: Error {
        case noItemFound
        case unexpectedItemData
        case unhandledError
    }
    
    static func reduceLoadingFailed(state: State, event: Event) -> State{
        return .goToLogin
    }
    
    static func whenLoading() -> Feedback<State, Event>{
        Feedback{ (state: State) -> AnyPublisher<Event, Never> in
            return Empty().eraseToAnyPublisher()
        }
    }
    
    static func userInput(input: AnyPublisher<Event, Never>) -> Feedback<State, Event>{
        Feedback { _ in input }
    }
}
