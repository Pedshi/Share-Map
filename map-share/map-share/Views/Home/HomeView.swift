//
//  HomeView.swift
//  map-share
//
//  Created by Pedram Shirmohammad on 2021-03-09.
//

import SwiftUI
import Combine

struct HomeView: View {
    @ObservedObject var viewModel : HomeViewModel
    
    @State private var unAuthorized = false
    
    var body: some View {
        content()
            .onReceive(viewModel.$state, perform: { state in
                switch state {
                case .loadingFailed:
                    unAuthorized = true
                default:
                    print("-")
                }
                
        })
    }
    
    private func content() -> some View {
        switch viewModel.state {
        case .idle:
            return homeScreen().eraseToAnyView()
        case .loading:
            return spinner().eraseToAnyView()
        case .loadingFailed:
            return homeScreen().eraseToAnyView()
        case .goToLogin:
            return EmptyView().eraseToAnyView()
        }
    }
    
    private func homeScreen() -> some View{
        NavigationView{
            TabView{
                Text("First")
                    .tabItem { Text("first") }
                Text("Second")
                    .tabItem { Text("second") }
            }.background(NavigationLink(
                            destination: LoginView(viewModel: LoginViewModel()),
                            isActive: $unAuthorized,
                            label: {
                                Text("")
                            }))
            .onChange(of: unAuthorized, perform: { value in
                print("value : \(value)")
            })
        }
        
    }
    
    private func spinner() -> some View {
        ProgressView()
    }
    
    private func goToLoginView() -> some View {
        NavigationView{
            NavigationLink(
                destination: LoginView(viewModel: LoginViewModel()),
                isActive: .constant(true),
                label: {
                    Text("")
                })
        }
        .ignoresSafeArea()
//        .navigationBarHidden(true)
    }
    
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: HomeViewModel(state: .idle))
    }
}
