//
//  LoginView.swift
//  map-share
//
//  Created by Pedram Shirmohammad on 2021-03-08.
//

import SwiftUI
import Combine

struct LoginView: View {
    @ObservedObject var viewModel : LoginViewModel
    @Environment(\.presentationMode) var presentationMode : Binding<PresentationMode>
    
    @State private var userEmail = ""
    @State private var userPassword = ""
    
    var body: some View {
        VStack{
            content()
        }
        .navigationBarHidden(true)
        .ignoresSafeArea()
    }
    
    private func content() -> some View{
        switch viewModel.state {
        case .idle:
            return LoginForm(goToHomePage: false)
                    .environmentObject(viewModel)
                    .eraseToAnyView()
        case .loading:
            return Text("Loading").eraseToAnyView()
        case .loadingFail:
            return Text("Loading failed").eraseToAnyView()
        case .loggingIn:
            self.presentationMode.wrappedValue.dismiss()
            return EmptyView().eraseToAnyView()
        }
    }

}

struct LoginForm: View{
    @EnvironmentObject var viewModel : LoginViewModel

    @State var email = ""
    @State var password = ""
    @State var goToHomePage : Bool
    
    var body: some View{
        ZStack{
            VStack{
                TextField("Email", text: $email)
                SecureField("Password", text: $password)
                Button("Login"){
                    viewModel.send(event: .onlogin(email.lowercased(), password))
                }
            }.padding()
//            NavigationLink(
//                destination: HomeView(viewModel: HomeViewModel(state: .idle)),
//                isActive: $goToHomePage,
//                label: {
//                    Text("")
//            })
        }
    }
}









struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: LoginViewModel())//.environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
