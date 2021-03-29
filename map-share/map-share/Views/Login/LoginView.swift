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
            content()
        }
        .navigationBarHidden(true)
        .ignoresSafeArea()
    }

    @ViewBuilder
    private func content() -> some View {
        switch viewModel.state {
        case .authenticating:
            spinner
        case .authenticated:
            goToHomeView
        case .loggingIn:
            spinner
        case .loginFail:
            Text("LOGIN FAILED")
        case .idle:
            LoginForm(goToHomePage: false)
                    .environmentObject(viewModel)
        case .refreshingToken:
            spinner
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
                    .accessibility(identifier: "loginEmailField")
                SecureField("Password", text: $password)
                    .accessibility(identifier: "loginPasswordField")
                Button("Login"){
                    viewModel.send(event: .onLoginReq(
                                    email: email.lowercased(),
                                    password: password)
                    )
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
