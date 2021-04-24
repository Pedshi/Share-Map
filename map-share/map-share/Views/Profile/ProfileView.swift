//
//  ProfileView.swift
//  map-share
//
//  Created by Pedram Shirmohammad on 2021-04-24.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    
    var body: some View {
        content()
    }
    
    @ViewBuilder
    func content() -> some View{
        switch viewModel.state {
        case .loading:
            spinner
        case let .idle(places, email):
            UserProfileView(places: places, email: email)
        case .loadingFailed:
            loadingFailed
        }
    }
    
    private var spinner: some View {
        ProgressView()
    }
    
    private var loadingFailed: some View {
        VStack{
            Image(systemName: "wifi.slash")
                .foregroundColor(.secondary)
                .imageScale(.large)
            Text("Failed to fetch saved locations.")
                .padding(Space.times2.rawValue)
        }
    }
}

struct UserProfileView: View {
    
    var places: [Place]
    var email: String
    
    var body: some View {
        Form{
            Section(header: Text("E-mail")){
                Text(email)
            }
            
            Section(header: Text("Saved Places")){
                ForEach(places){ place in
                    Text(place.name)
                }
            }
        }
    }
}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(viewModel: ProfileViewModel())
    }
}
