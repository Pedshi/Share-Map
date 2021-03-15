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
    
    init(state: State) {
        self.state = state
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
            print("whenloading State: \(state)")
            guard case .loading = state else { return Empty().eraseToAnyPublisher() }
            
            let user = try? KeyChainItem().readItem()
            var urlReq = UserRequest().valToken(email: user!.account, token: user!.token)
            urlReq.req.httpBody = urlReq.json
            
            return URLSession.shared.dataTaskPublisher(for: urlReq.req)
                .tryMap { (data, response) in
                    guard let httpResponse = response as? HTTPURLResponse,
                          httpResponse.statusCode < 300
                          else { throw ReqError.unhandledError}
                }
                .map{ Event.onLoadingSuccess }
                .catch{ Just(Event.onLoadingFail($0)) }
                .eraseToAnyPublisher()
            
            
//            return Just(0)
//                .map { $0 }
//                .map { $0 == 1 ? Event.onLoadingSuccess: Event.onLoadingFail }
//                .catch{ _ in Just(Event.onLoadingFail) }
//                .eraseToAnyPublisher()
        }
    }
    
    static func userInput(input: AnyPublisher<Event, Never>) -> Feedback<State, Event>{
        Feedback { _ in input }
    }
}



//    init(){
//        isTokenValid()
//    }
//
//    func isTokenValid(){
//        // Se om token finns
//        do {
//            //let user = try KeyChainItem().readItem()
//            let resp = UserRequest().valToken(email: "pedram.shir@hotmail.com", token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2MDE3ZmVhZGEyMzA4ZDgwYTZjMDZiOWQiLCJpYXQiOjE2MTUzMjM0ODAsImV4cCI6MTYxNTMyNzA4MH0.PJxbP5jPjDZrYTsknT8NEZtv2sbgyPPvYX3EjQVd9eo")
//
//
//            URLSession.shared.uploadTask(with: resp.req, from: resp.json){[weak self] data, response, error in
//                //CLEAN UP: START
//                if let e = error {
//                    print("Error: \(e)")
//                    return
//                }
//                guard let httpResponse = response as? HTTPURLResponse else {
//                    print("Could not convert Response to HTTPURLResponse")
//                    return
//                }
//                guard httpResponse.statusCode == 200 else{
//                    // Should try to login with KeyChain credentials and if not able go to login page
//                    print("Unauthorized Token Request")
//                    return
//                }
//                //CLEAN UP: END
//                print("Valid Token!")
//                DispatchQueue.main.async {
//                    self?.loggedIn = true
//                }
//            }.resume()
//
//
//
//        } catch KeyChainItem.KeychainError.noItemFound {
//            //Send to Login Page
//        }catch {
//            print("Other Errors")
//        }
//    }
//
//    private func trimCookie(cookie: String) -> String{
//        var from = cookie.firstIndex(of: "=")!
//        from = cookie.index(from, offsetBy: 1)
//        var trimmed = cookie.suffix(from: from)
//        let to = trimmed.firstIndex(of: ";")!
//        trimmed = trimmed.prefix(upTo: to)
//        return String(trimmed)
//    }
