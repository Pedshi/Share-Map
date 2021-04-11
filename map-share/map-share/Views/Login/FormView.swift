//
//  FormView.swift
//  map-share
//
//  Created by Pedram Shirmohammad on 2021-04-06.
//

import SwiftUI

struct FormView: View {
    
    //MARK: - Variables
    @State private var email = ""
    @State private var password = ""
    @State private var passwordRepeat = ""
    
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
                        TextField(mailFieldText, text: $email)
                    }
                    .padding(.top, Space.times3.rawValue)

                    VStack{
                        VStack(alignment: .leading){
                            passwordLabel
                            SecureField(pswrdText, text: $password)
                        }
                        VStack(alignment: .leading){
                            rePasswordLabel
                            SecureField(rePswrdText, text: $passwordRepeat)
                        }
                    }
                    
                    Button(action: {
                        
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
