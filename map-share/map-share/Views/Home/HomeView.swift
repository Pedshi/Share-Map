//
//  HomeView.swift
//  map-share
//
//  Created by Pedram Shirmohammad on 2021-03-09.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel : HomeViewModel
    
    @State private var unAuthorized = false
    
    var body: some View {
        content()
            .ignoresSafeArea()
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
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
        TabView{
            Text("First")
                .tabItem { Text("first") }
            Text("Second")
                .tabItem { Text("second") }
        }
    }
    
    private func spinner() -> some View {
        ProgressView()
    }

}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: HomeViewModel())
    }
}
