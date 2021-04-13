//
//  RegisterView.swift
//  map-share
//
//  Created by Pedram Shirmohammad on 2021-04-06.
//

import SwiftUI

struct RegisterView: View {
    
    @EnvironmentObject var viewModel : LoginViewModel
    
    //MARK: - COMPONENTS
    var registerButton = TokenButton(
        capsuleText: "Register with E-mail",
        size: .large
    )
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView{
                ZStack(alignment: .top){
                    VStack(spacing: geometry.size.height * Layout.oneTwentieth.rawValue){
                        Image("standing")
                            .fitResize(height: geometry.size.height * Layout.oneHalf.rawValue)

                        VStack{
                            NavigationLink(destination: FormView().environmentObject(viewModel)){
                                registerButton.buttonLabel
                            }
                            .buttonStyle(registerButton.buttonStyle)
                            
                            Button(action: {}, label: {
                                 Text("Sign in with Apple")
                                     .fontWeight(.semibold)
                                     .padding(.vertical, 20)
                                     .padding(.horizontal, 90)
                                     .background(Color.black)
                                     .foregroundColor(.white)
                                     .cornerRadius(30)
                             })
                        }  
                    }
                }
                .navigationBarTitle(pageTitle)
                .fullScreen(alignment: .top)
            }
            .ignoresSafeArea(.container)
        }
    }
    
    //MARK: - Texts
    let pageTitle = "Register"
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RegisterView()
            RegisterView()
                .previewDevice("iPhone 8")
        }
    }
}
