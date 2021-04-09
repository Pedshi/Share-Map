//
//  LoginView.swift
//  map-share
//
//  Created by Pedram Shirmohammad on 2021-03-08.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel : LoginViewModel
//    @Environment(\.presentationMode) var presentationMode : Binding<PresentationMode>
    
    @State private var userEmail = ""
    @State private var userPassword = ""
    
    var body: some View {
        content()
            .navigationBarHidden(true)
            .ignoresSafeArea(.container)
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

    @State private var email = ""
    @State private var password = ""
    @State var goToHomePage : Bool
    @State private var showRegister : Bool = false
    
    var body: some View{
        GeometryReader{ geometry in
            ZStack{
                VStack{
                    Image("reading-by-tree")
                        .fitResize(height: geometry.size.height * 0.4)
                        .padding(.vertical, geometry.size.height * 0.05)
                    signInForm(size: geometry.size)
                }
                .padding()
                .fullScreen(alignment: .top)
                .sheet(isPresented: $showRegister){ RegisterView() }
            }
        }
    }
    
    func signInForm(size: CGSize) -> some View {
        VStack(spacing: VSpace.small.rawValue){
            TextField(emailText, text: $email)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .accessibility(identifier: "loginEmailField")
            
            SecureField(pswrdText, text: $password)
                .accessibility(identifier: "loginPasswordField")

            Button("Sign In"){
                viewModel.send(event: .onLoginReq(
                                email: email.lowercased(),
                                password: password)
                )
            }
            .buttonStyle(ActionButton(width: 210))
            
            HStack{
                Text("Don't have an account?")
                Button("Register", action: {
                    showRegister = true
                })
            }
        }
        .textFieldStyle(SingleTextFieldStyle(width: size.width * 0.75))
    }
    
    let emailText = "E-mail"
    let pswrdText = "Password"
}



struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LoginView(viewModel: LoginViewModel())
            LoginView(viewModel: LoginViewModel())
                .previewDevice("iPhone 8")
                
        }//.environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
