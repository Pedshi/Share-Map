//
//  LoginView.swift
//  map-share
//
//  Created by Pedram Shirmohammad on 2021-03-08.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel : LoginViewModel
    @Environment(\.presentationMode) var presentationMode : Binding<PresentationMode>
    
    @State private var userEmail = ""
    @State private var userPassword = ""
    
    var body: some View {
        VStack{
            content
        }
        .navigationBarHidden(true)
        .ignoresSafeArea()
    }

    private var content : some View {
        switch viewModel.state {
        case .authenticating:
            return spinner.eraseToAnyView()
        case .authenticated:
            return goToHomeView.eraseToAnyView()
        case .authenticationFail:
            viewModel.send(event: .onAuth)
            return Text("FAILED to AUTHENTICATE").eraseToAnyView()
        case .loggingIn:
            return spinner.eraseToAnyView()
        case .loginFail:
            return Text("LOGIN FAILED").eraseToAnyView()
        case .idle:
            return LoginForm(goToHomePage: false)
                    .environmentObject(viewModel)
                    .eraseToAnyView()
        case .refreshingToken:
            return spinner.eraseToAnyView()
        }
    }
    
    private var spinner: some View {
        ProgressView()
    }
    
    private var goToHomeView: some View {
        NavigationView{
            NavigationLink(
                destination: HomeView(viewModel: HomeViewModel()),
                isActive: .constant(true),
                label: {
                    Text("")
                })
                .navigationBarHidden(true)
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
                    viewModel.send(event: .onLoginReq(email.lowercased(), password))
                }
            }
            .padding()
        }
    }
}









struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: LoginViewModel())//.environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
