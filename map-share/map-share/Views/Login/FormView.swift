//
//  FormView.swift
//  map-share
//
//  Created by Pedram Shirmohammad on 2021-04-06.
//

import SwiftUI

struct FormView: View {
    
    @EnvironmentObject var viewModel : LoginViewModel
    
    //MARK: - Variables
    @State private var email = ""
    @State private var password = ""
    @State private var passwordRepeat = ""
    @State private var mailFormatCorrect: Bool?
    @State private var passwordFormatCorrect: Bool?
    @State private var rePasswordFormatCorrect: Bool?
    
    //MARK: - Components
    var registerButton = TokenButton(capsuleText: "Register", size: .large)
    var emailLabel = TokenTextFieldLabel(name: "E-mail")
    var passwordLabel = TokenTextFieldLabel(name: "Password")
    var rePasswordLabel = TokenTextFieldLabel(name: "Repeat Password")
    
    
    var body: some View {
        GeometryReader{ geometry in
            ZStack{
                VStack(alignment: .leading, spacing: Space.times5.rawValue){

                    VStack(alignment: .leading){
                        emailLabel
                        fieldWithValidIndicator(condition: mailFormatCorrect){
                            TextField(mailFieldText, text: $email, onEditingChanged: { began in
                                if !began {
                                    mailFormatCorrect = StringValidator.validateEmail(email)
                                }
                            })
                        }
                    }
                    .padding(.top, Space.times3.rawValue)

                    VStack(alignment: .leading, spacing: Space.times1.rawValue){
                        VStack(alignment: .leading){
                            passwordLabel
                            fieldWithValidIndicator(condition: passwordFormatCorrect){
                                SecureField(pswrdText, text: $password){
                                    passwordFormatCorrect = StringValidator.validatePassword(password)
                                }
                            }
                        }
                        VStack(alignment: .leading){
                            rePasswordLabel
                            fieldWithValidIndicator(condition: rePasswordFormatCorrect){
                                SecureField(rePswrdText, text: $passwordRepeat){
                                    rePasswordFormatCorrect = StringValidator.validatePassword(
                                        password: password,
                                        rePassword: passwordRepeat
                                    )
                                }
                            }
                        }
                    }
                    
                    Button(action: {
                        mailFormatCorrect = StringValidator.validateEmail(email)
                        passwordFormatCorrect = StringValidator.validatePassword(password)
                        rePasswordFormatCorrect = StringValidator.validatePassword(password: password, rePassword: passwordRepeat)
                        guard mailFormatCorrect!,
                              passwordFormatCorrect!,
                              rePasswordFormatCorrect! else { return }
                        viewModel.send(event: .onRegisterReq(email: email, password: password))
                    }){ registerButton.buttonLabel }
                        .buttonStyle(registerButton.buttonStyle)
                }
                .textFieldStyle(
                    TokenTextFieldStyle(width: geometry.size.width * Layout.threeQuarters.rawValue)
                )
            }
            .navigationBarTitle(navBarTitle)
            .padding(.leading, Space.times2.rawValue)

        }
    }
    
    func fieldWithValidIndicator<Content: View>(condition: Bool?, inputField: @escaping () -> Content ) -> some View{
        HStack{
            inputField()
            if let condition = condition {
                Image(systemName: condition ? "checkmark": "xmark" )
                    .foregroundColor(condition ? .green: .red)
                    .imageScale(.large)
            }
        }
    }
    
    //MARK: - Text
    let navBarTitle = "With E-mail"
    let mailFieldText  = "E-mail"
    let pswrdText = "Password"
    let rePswrdText = "Repeat Password"
}

struct FormView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            FormView()
            FormView()
                .previewDevice("iPhone 8")
        }
    }
}

enum StringValidator{
    static func validateEmail(_ email: String) -> Bool {
        let emailPattern = #"^\S+@\S+\.\S+$"#
        return nil != email.range(of: emailPattern, options: .regularExpression)
    }
    
    static func validatePassword(_ password: String) -> Bool {
        password.count >= 8
    }
    
    static func validatePassword(password: String, rePassword: String) -> Bool {
        password.count >= 8 && password == rePassword
    }
}
