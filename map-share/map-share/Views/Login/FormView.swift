//
//  FormView.swift
//  map-share
//
//  Created by Pedram Shirmohammad on 2021-04-06.
//

import SwiftUI

struct FormView: View {
    
    @State private var email = ""
    @State private var password = ""
    @State private var passwordRepeat = ""
    
    var registerButton = TokenButton(buttonText: "Register", size: .large)
    
    var body: some View {
        GeometryReader{ geometry in
            ZStack{
                VStack(alignment: .leading, spacing: VSpace.medium.rawValue){
                    emailField
                    VStack{
                        passwordField(pswrdText, text: $password)
                        passwordField(rePswrdText, text: $passwordRepeat)
                    }
                    
                    Button(action: {
                        
                    }, label: {
                        registerButton.buttonLabel
                    }).buttonStyle(registerButton.buttonStyle)
                    
//                    Button("Register"){
//
//                    }
//                    .buttonStyle(ActionButton(width: geometry.size.width * 0.9))
////                    .padding(.horizontal, Pad.large1.rawValue)
                }
                .textFieldStyle(SingleTextFieldStyle(width: geometry.size.width * 0.75))
            }
            .navigationBarTitle(navBarTitle)
            .padding(.leading, 10)
//            .fullScreen(alignment: .top)
        }
    }
    
    var emailField: some View {
        VStack(alignment: .leading){
            Text(mailFieldText)
                .inputLabel()
            TextField(mailFieldText, text: $email)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .padding(.leading, Pad.medium.rawValue)
        }
        .padding(.top, Pad.large1.rawValue)
    }
    
    func passwordField(_ placeHolder: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading){
            Text(placeHolder)
                .inputLabel()
            SecureField(placeHolder, text: text)
                .padding(.leading, Pad.medium.rawValue)
        }
    }
    
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
