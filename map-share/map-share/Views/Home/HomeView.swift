//
//  HomeView.swift
//  map-share
//
//  Created by Pedram Shirmohammad on 2021-03-09.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel : HomeViewModel

    var body: some View {
        ZStack{
        RoundedRectangle(cornerRadius: 25.0)
            .foregroundColor(.red)
        }.ignoresSafeArea()
        .navigationBarHidden(true)
//        NavigationView{
//            VStack{
//
//                NavigationLink(
//                    destination: LoginView(viewModel: LoginViewModel()),
//                    isActive: $viewModel.loggedIn,
//                    label: {
//                        Text("hej")
//                    })
//            }
//        }
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: HomeViewModel())
    }
}
