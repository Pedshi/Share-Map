//
//  RegisterView.swift
//  map-share
//
//  Created by Pedram Shirmohammad on 2021-04-06.
//

import SwiftUI

struct RegisterView: View {
    var body: some View {
        GeometryReader { geometry in
            NavigationView{
                ZStack(alignment: .top){
                    VStack(spacing: geometry.size.height * 0.05){
                        Image("standing")
                            .fitResize(height: geometry.size.height * 0.5)
                            .padding(.top, geometry.size.height * 0.03)

                        VStack(spacing: VSpace.small.rawValue){
                            NavigationLink(destination: FormView()){
                                Text("Register with E-mail")
                            }
                            .buttonStyle(ActionButton(width: 320))
                            
                            Button(action: {
                                
                            }, label: {
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
                .navigationBarTitle("Register")
                .fullScreen(alignment: .top)
            }
            .ignoresSafeArea(.container)
        }
    }
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
