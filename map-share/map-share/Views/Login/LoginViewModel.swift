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
        case authenticationFail(Error)
        case refreshingToken
        case idle
        case loggingIn(String, String)
        case loginFail(Error)
    }
    
    enum Event {
        case onAuth
        case onAuthSuccess
        case onAuthFail(Error)
        case onRefreshToken
        case onLoginReq(String, String)
        case onLoginSuccess
        case onLoginFail(Error)
    }
    
    enum ReqError: Error {
        case noItemFound
        case unexpectedItemData
        case unhandledError
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
        case let .authenticationFail(error):
            return reduceAuthenticationFail(state: state, event: event, error: error)
        case .refreshingToken:
            return reduceRefreshinToken(state: state, event: event)
        case .idle:
            return reduceIdle(state: state, event: event)
        case .loggingIn:
            return reduceLoggingIn(state: state, event: event)
        case .loginFail:
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
        case let .onAuthFail(error):
            return .authenticationFail(error)
        case .onRefreshToken:
            return .refreshingToken
        default:
            return state
        }
    }
    
    static func reduceAuthenticationFail(state: State, event: Event, error: Error) -> State {
        // Fix so it refreshes token
        return .idle
    }
    
    static func reduceIdle(state: State, event: Event) -> State {
        switch event {
        case let .onLoginReq(email, password):
            return .loggingIn(email, password)
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
    
    static func whenAuthenticating() -> Feedback<State, Event>{
        Feedback { (state: State) -> AnyPublisher<Event, Never> in
            guard case .authenticating = state else { return Empty().eraseToAnyPublisher() }
            
            do{
                let user = try KeyChainItem.Token.readItem()
                var urlReq = UserRequest().valToken(email: user.account, token: user.secretValue)
                urlReq.req.httpBody = urlReq.json
                return URLSession.shared.dataTaskPublisher(for: urlReq.req)
                    .tryMap { (data, response) in
                        print("REPONSE FROM AUTHENTICATION")
                        guard let httpResponse = response as? HTTPURLResponse,
                              httpResponse.statusCode < 300
                              else { throw ReqError.unhandledError}
                    }
                    .map{ Event.onAuthSuccess }
                    .catch{ _ in Just(Event.onRefreshToken) }
                    .eraseToAnyPublisher()
            }catch {
                print("In Catch in when Authenticating");
                return Just( Event.onRefreshToken ).eraseToAnyPublisher()
//                return Just(Event.onAuthFail(ReqError.unhandledError)).eraseToAnyPublisher()
            }
        }
    }
    
    static func whenRefreshToken() -> Feedback<State, Event> {
        Feedback { (state: State) -> AnyPublisher<Event, Never> in
            guard case .refreshingToken = state else { return Empty().eraseToAnyPublisher() }
            
            do {
                let user = try KeyChainItem.Passwrd.readItem()
                let convToJson = [
                    "email" : user.account,
                    "password" : user.secretValue
                ]
                let json = try! JSONSerialization.data(withJSONObject: convToJson, options: [])
                var urlReq = URLRequest(url: URL(string: "http://localhost:3001/api/anvandare/loggain")!)
                urlReq.httpMethod = "POST"
                urlReq.setValue("application/json", forHTTPHeaderField: "Content-Type")
                urlReq.httpBody = json
                
                return URLSession.shared.dataTaskPublisher(for: urlReq)
                        .tryMap{ (data, response) in
                            guard let httpResponse = response as? HTTPURLResponse,
                                  httpResponse.statusCode < 300
                            else{ throw ReqError.unhandledError }
                            if let cookie = httpResponse.value(forHTTPHeaderField: "Set-Cookie") {
                                let token = LoginViewModel.trimCookie(cookie: cookie)
                                try? KeyChainItem.Token.saveItem(secretValue: token, account: user.account.lowercased())
                                print("Refreshed Token")
                            }
                        }
                        .map{ Event.onAuthSuccess }
    //                    .map{ $0 == 200 ? Event.onLoginSuccess : Event.onLoginFail(ReqError.unhandledError) }
                        .catch{ Just(Event.onAuthFail($0)) }
                        .eraseToAnyPublisher()
                
            }catch{
                return Just(Event.onAuthFail(ReqError.unhandledError)).eraseToAnyPublisher()
            }
            
        }
    }
    
    static func whenLoggingIn() -> Feedback<State, Event>{
        Feedback { (state: State) -> AnyPublisher<Event, Never> in
            guard case let .loggingIn(email, password) = state else { return Empty().eraseToAnyPublisher() }
            print("Login Request")
            let convToJson = [
                "email" : email,
                "password" : password
            ]
            let json = try! JSONSerialization.data(withJSONObject: convToJson, options: [])
            
            var urlReq = URLRequest(url: URL(string: "http://localhost:3001/api/anvandare/loggain")!)
            urlReq.httpMethod = "POST"
            urlReq.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlReq.httpBody = json
            
            return URLSession.shared.dataTaskPublisher(for: urlReq)
                    .tryMap{ (data, response) in
                        guard let httpResponse = response as? HTTPURLResponse,
                              httpResponse.statusCode < 300
                        else{ throw ReqError.unhandledError }
                        
                        if let cookie = httpResponse.value(forHTTPHeaderField: "Set-Cookie") {
                            let token = LoginViewModel.trimCookie(cookie: cookie)
                            try? KeyChainItem.Token.saveItem(secretValue: token, account: email.lowercased())
                            try? KeyChainItem.Passwrd.saveItem(secretValue: password, account: email.lowercased())
                        }
                    }
                    .map{ Event.onLoginSuccess }
//                    .map{ $0 == 200 ? Event.onLoginSuccess : Event.onLoginFail(ReqError.unhandledError) }
                    .catch{ Just(Event.onLoginFail($0)) }
                    .eraseToAnyPublisher()
        }
    }
    
    static func userInput(input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
        Feedback{ _ in input }
    }
    
    static func trimCookie(cookie: String) -> String{
        var from = cookie.firstIndex(of: "=")!
        from = cookie.index(from, offsetBy: 1)
        var trimmed = cookie.suffix(from: from)
        let to = trimmed.firstIndex(of: ";")!
        trimmed = trimmed.prefix(upTo: to)
        return String(trimmed)
    }
}
