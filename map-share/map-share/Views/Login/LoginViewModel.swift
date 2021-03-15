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
        state = .idle
        
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
        bag.removeAll()
    }
    
    func send(event: Event){
        input.send(event)
    }
}

// MARK: - States and Events

extension LoginViewModel {
    enum State {
        case idle
        case loading(String, String)
        case loadingFail
        case loggingIn
    }
    
    enum Event {
        case onlogin(String, String)
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
        case .idle:
            return reduceIdle(state: state, event: event)
        case .loading:
            return reduceLoading(state: state, event: event)
        case .loadingFail:
            return .idle
        case .loggingIn:
            return reduceLoggingIn(state: state, event: event)
        }
    }
    
    static func reduceIdle(state: State, event: Event) -> State{
        switch event {
        case let .onlogin(email, password):
            return .loading(email, password)
        default:
            return state
        }
    }
    
    static func reduceLoading(state: State, event: Event) -> State {
        switch event {
        case .onLoginFail:
            return .loadingFail
        case .onLoginSuccess:
            return .loggingIn
        default:
            return state
        }
    }
    
    static func reduceLoggingIn(state: State, event: Event) -> State{
        return .idle
    }
    
    
    // MARK: - Feedback
    
    
    static func whenLoading() -> Feedback<State, Event>{
        Feedback { (state: State) -> AnyPublisher<Event, Never> in
            guard case let .loading(email, password) = state else { return Empty().eraseToAnyPublisher() }
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
                        
//                        if let cookie = httpResponse.value(forHTTPHeaderField: "Set-Cookie") {
//                            let token = LoginViewModel.trimCookie(cookie: cookie)
//                            try? KeyChainItem().saveItem(token: token, account: email.lowercased())
//                            print("Logged in")
//                        }
                    }
                    .map{ Event.onLoginSuccess }
//                    .map{ $0 == 200 ? Event.onLoginSuccess : Event.onLoginFail(ReqError.unhandledError) }
                    .catch{ Just(Event.onLoginFail($0)) }
                    .eraseToAnyPublisher()
        }
    }
    
    static func trimCookie(cookie: String) -> String{
        var from = cookie.firstIndex(of: "=")!
        from = cookie.index(from, offsetBy: 1)
        var trimmed = cookie.suffix(from: from)
        let to = trimmed.firstIndex(of: ";")!
        trimmed = trimmed.prefix(upTo: to)
        return String(trimmed)
    }
    
    static func userInput(input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
        Feedback{ _ in input }
    }
}



//func isTokenValid(email: String, password: String){
//        // Se om token finns
//        do {
//            let user = try KeyChainItem().readItem()
//            UserRequest().validateTokenRequest(email: user.account, token: user.token)
//        } catch KeyChainItem.KeychainError.noItemFound {
//            //Send to Login Page
//            UserRequest().loginRequest(email: email, password: password)
//        }catch {
//            print("Other Errors")
//        }
//        //Om den finns gör ett urlReq och se om token är gilitg
//        //Annars gå till loginRequest/Login Page
//
//        //Om giltig gå till Home sidan
//        //Annars gå till refreshToken
//    }
//
//    func refreshToken(){
//        //Se om användarnamn och lösenord finns
//
//        //Om den finns för ett URLReq till api/login
//        //Ta emot ny token, uppdatera sparad token och skicka till Home sidan
//        //Annars gå till loginRequest/Login page
//    }
//
//    func loginRequest(){
//        //Gör ett URLReq till login med email och lösen
//
//        //Om misslyckad uppdatera view
//
//        //Om lyckad spara email och lösen, spara token och gå till Home sidan
//    }
