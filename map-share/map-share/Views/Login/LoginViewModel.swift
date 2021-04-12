//
//  LoginViewModel.swift
//  map-share
//
//  Created by Pedram Shirmohammad on 2021-03-08.
//

import Foundation
import Combine

class LoginViewModel : ObservableObject{
    @Published private(set) var state : State
    
    private var bag = Set<AnyCancellable>()
    
    private let input = PassthroughSubject<Event, Never>()
    
    init() {
        state = .authenticating

        Publishers.system(
            initial: state,
            reduce: Self.reduce,
            scheduler: RunLoop.main,
            feedbacks: [
                Self.whenAuthenticating(),
                Self.whenLoggingIn(),
                Self.whenRefreshToken(),
                Self.whenRegistering(),
                Self.userInput(input: input.eraseToAnyPublisher())
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

// MARK: - States and Events

extension LoginViewModel {
    enum State {
        case authenticating
        case authenticated
        case refreshingToken
        
        case idle
        
        case loggingIn(String, String)
        case loginFail(Error)
        
        case register(String, String)
    }
    
    enum Event {
        case onAuthSuccess
        case onAuthFail(Error)
        case onRefreshToken
        
        case onLoginReq(email: String, password: String)
        case onLoginSuccess
        case onLoginFail(Error)
        
        case onRegisterReq(email: String, password: String)
        case onRegisterSuccess
        case onRegisterFail(Error)
    }
}

// MARK: - Reducer

extension LoginViewModel {
    static func reduce(_ state: State, _ event: Event) -> State {
        print("current State : \(state)")
        print("current Event : \(event)")
        print("-------------------------------------")
        switch state {
        case .authenticating:
            return reduceAuthenticating(state: state, event: event)
        case .authenticated:
            return state
        case .refreshingToken:
            return reduceRefreshinToken(state: state, event: event)
        case .idle:
            return reduceIdle(state: state, event: event)
        case .loggingIn:
            return reduceLoggingIn(state: state, event: event)
        case .loginFail:
            return .idle
        case .register:
            return reduceRegister(state: state, event: event)
        }
    }
    
    static func reduceRegister(state: State, event: Event) -> State {
        switch event {
        case .onRegisterSuccess:
            return .idle // SHOULD GO TO HOME SCREEN INSTEAD
        case let .onRegisterFail(error):
            return .loginFail(error)
        default:
            return .idle
        }
    }
    
    static func reduceRefreshinToken(state: State, event: Event) -> State {
        switch event {
        case .onAuthSuccess:
            return.authenticated
        default:
            return .idle
        }
    }
    
    static func reduceAuthenticating(state: State, event: Event) -> State {
        switch event {
        case .onAuthSuccess:
            return .authenticated
        case .onAuthFail:
            return .idle
        case .onRefreshToken:
            return .refreshingToken
        default:
            return state
        }
    }
    
    static func reduceIdle(state: State, event: Event) -> State {
        switch event {
        case let .onLoginReq(email, password):
            return .loggingIn(email, password)
        case let .onRegisterReq(email, password):
            return .register(email, password)
        default:
            return state
        }
    }
    
    static func reduceLoggingIn(state: State, event: Event) -> State {
        switch event {
        case let .onLoginFail(error):
            return .loginFail(error)
        case .onLoginSuccess:
            return .authenticated
        default:
            return state
        }
    }
    
    // MARK: - Feedback
    
    static func whenRegistering() -> Feedback<State, Event>{
        Feedback { (state: State) -> AnyPublisher<Event, Never> in
            guard case let .register(email, password) = state else { return Empty().eraseToAnyPublisher() }
            
            return API.User.registerRequest(email: email, password: password)
                .map{ Event.onRegisterSuccess }
                .catch{ Just(Event.onRegisterFail($0)) }
                .eraseToAnyPublisher()
        }
    }
    
    static func whenAuthenticating() -> Feedback<State, Event>{
        Feedback { (state: State) -> AnyPublisher<Event, Never> in
            guard case .authenticating = state else { return Empty().eraseToAnyPublisher() }
            
            do{
                let user = try KeyChainManager.Token.readItem()
                return API.User.validateTokenRequest(email: user.account, token: user.secretValue)
                        .map{ Event.onAuthSuccess }
                        .catch{ _ in Just(Event.onRefreshToken) }
                        .eraseToAnyPublisher()
            }catch {
                return Just(Event.onAuthFail(error)).eraseToAnyPublisher()
            }
        }
    }
    
    static func whenRefreshToken() -> Feedback<State, Event> {
        Feedback { (state: State) -> AnyPublisher<Event, Never> in
            guard case .refreshingToken = state else { return Empty().eraseToAnyPublisher() }

            do {
                let user = try KeyChainManager.Passwrd.readItem()
                return API.User.loginRequest(email: user.account, password: user.secretValue)
                        .map{ Event.onAuthSuccess }
                        .catch{ Just(Event.onAuthFail($0)) }
                        .eraseToAnyPublisher()
            }catch {
                return Just(Event.onAuthFail(error)).eraseToAnyPublisher()
            }
        }
    }
    
    static func whenLoggingIn() -> Feedback<State, Event>{
        Feedback { (state: State) -> AnyPublisher<Event, Never> in
            guard case let .loggingIn(email, password) = state else { return Empty().eraseToAnyPublisher() }
            
            return API.User.loginRequest(email: email, password: password)
                    .map { Event.onLoginSuccess }
                    .catch { Just(Event.onLoginFail($0)) }
                    .eraseToAnyPublisher()
        }
    }
    
    static func userInput(input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
        Feedback{ _ in input }
    }
}
