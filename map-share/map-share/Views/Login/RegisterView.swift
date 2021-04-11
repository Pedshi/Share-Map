//
//  RegisterView.swift
//  map-share
//
//  Created by Pedram Shirmohammad on 2021-04-06.
//

import SwiftUI

struct RegisterView: View {
    
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
                            .padding(.top, geometry.size.height * Layout.oneTwentieth.rawValue)

                        VStack{
                            NavigationLink(destination: FormView()){
                                registerButton.buttonLabel
                            }
                            .buttonStyle(registerButton.buttonStyle)
                        }.frame(width: 100, height: 100, alignment: .center) //reported SwiftUI bug
                        
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
