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
        case .loggingIn, .register:
            spinner
        case .loginFail:
            LoginForm(
                goToHomePage: false,
                registerSuccess: true,
                alertView: loginFailedAlert
            )
                .environmentObject(viewModel)
        case let .idle(registerAlert):
            LoginForm(
                goToHomePage: false,
                registerSuccess: registerAlert,
                alertView: registerSuccessAlert
            )
                .environmentObject(viewModel)
        case .refreshingToken:
            spinner
        }
    }
    
    private var spinner: some View {
        ProgressView()
    }
    
    private var registerSuccessAlert: Alert {
        Alert(title: Text(successAlertText), dismissButton: .default(Text(dismissAlertText)))
    }
    
    private var loginFailedAlert: Alert {
        Alert(
            title: Text(loginFailText),
            dismissButton: .default(Text(dismissAlertText), action: { viewModel.send(event: .onDismissAlert) })
        )
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
    
    //MARK: - Texts
    let successAlertText = "Succefully registered account 🎉"
    let loginFailText = "Login with provided credentials failed!"
    let dismissAlertText = "OK"
    
}

struct LoginForm: View{
    
    @EnvironmentObject var viewModel : LoginViewModel

    //MARK: - Variables
    @State private var email = ""
    @State private var password = ""
    @State var goToHomePage : Bool
    @State var registerSuccess: Bool
    @State private var showRegister : Bool = false
    var alertView: Alert
    
    //MARK: - COMPONENTS
    var signInButton = TokenButton(capsuleText: "Sign In", size: .medium)
    var registerLink = TokenButton(linkText: "Register")
    
    var body: some View{
        GeometryReader{ geometry in
            ZStack{
                VStack{
                    Image(TokenImageName.reading.rawValue)
                        .fitResize(height: geometry.size.height * Layout.eightTwentieths.rawValue)
                        .padding(.vertical, geometry.size.height * Layout.oneTwentieth.rawValue)
                    signInForm(size: geometry.size)
                }
                .padding()
                .fullScreen(alignment: .top)
                .sheet(isPresented: $showRegister){ RegisterView().environmentObject(viewModel) }
            }.alert(isPresented: $registerSuccess){ alertView }
        }
    }
    
    func signInForm(size: CGSize) -> some View {
        VStack(spacing: Space.times3.rawValue){
            TextField(emailText, text: $email)
                .accessibility(identifier: "loginEmailField")
            SecureField(pswrdText, text: $password)
                .accessibility(identifier: "loginPasswordField")

            Button(action: {
                viewModel.send(event: .onLoginReq(
                                email: email.lowercased(),
                                password: password
                ))
            }){ signInButton.buttonLabel }
                .buttonStyle(signInButton.buttonStyle)
            
            HStack{
                Text(createAccountText)
                Button(action: {
                    showRegister = true
                }){ registerLink.buttonLabel }
                    .buttonStyle(registerLink.buttonStyle)
            }
        }
        .textFieldStyle(TokenTextFieldStyle(width: size.width * Layout.threeQuarters.rawValue))
    }
    
    //MARK: - Texts
    let emailText = "E-mail"
    let pswrdText = "Password"
    let createAccountText = "Don't Have an account?"
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
