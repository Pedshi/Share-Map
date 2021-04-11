//
//  InputField.swift
//  map-share
//
//  Created by Pedram Shirmohammad on 2021-04-11.
//

import Foundation
import SwiftUI

struct TokenTextField{
    
    let inputStyle: TokenTextFieldStyle
    let inputLabel: TokenTextFieldLabel
    
    init(descriptionText: String, width: CGFloat){
        inputStyle = TokenTextFieldStyle(width: width)
        inputLabel = TokenTextFieldLabel(name: descriptionText)
    }
    
}

struct TokenTextFieldLabel: View {
    let name: String
    
    func getView() -> some View {
        Text(name)
            .font(Font.Token.inputHint)
            .padding(.leading, Space.times2.rawValue)
            .padding(.bottom, -4)
    }
    
    var body: some View {
        getView()
    }
}

struct TokenTextFieldStyle: TextFieldStyle {
    var width : CGFloat
    
    func _body(configuration: TextField<_Label>) -> some View {
        configuration
            .padding(Space.times2.rawValue)
            .overlay(
                RoundedRectangle(cornerRadius: RadiusSize.large.rawValue)
                    .stroke(Color.Token.highlightBorder, lineWidth: 1)
            )
            .frame(width: width)
            .disableAutocorrection(true)
            .autocapitalization(.none)
    }
}
