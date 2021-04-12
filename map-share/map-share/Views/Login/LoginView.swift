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
                alertView: alertWith(title: loginFailText, button: dismissWithStateButton)
            )
                .environmentObject(viewModel)
        case .registerFail:
            LoginForm(
                goToHomePage: false,
                registerSuccess: true,
                alertView: alertWith(title: registerFailText, button: dismissWithStateButton)
            )
                .environmentObject(viewModel)
        case let .idle(registerAlert):
            LoginForm(
                goToHomePage: false,
                registerSuccess: registerAlert,
                alertView: alertWith(title: successAlertText, button: dismissButton)
            )
                .environmentObject(viewModel)
        case .refreshingToken:
            spinner
        }
    }
    
    private var spinner: some View {
        ProgressView()
    }
    
    private var dismissButton: Alert.Button {
        Alert.Button.default(Text(dismissAlertText))
    }
    
    private var dismissWithStateButton: Alert.Button {
        Alert.Button.default(Text(dismissAlertText), action: { viewModel.send(event: .onDismissAlert) })
    }
    
    func alertWith(title: String, button: Alert.Button) -> Alert{
        Alert(title: Text(title), dismissButton: button)
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
    let registerFailText = "Registeration failed!"
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
