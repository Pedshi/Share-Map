//
//  Button.swift
//  map-share
//
//  Created by Pedram Shirmohammad on 2021-04-11.
//

import Foundation
import SwiftUI

struct TokenButton {
    
    let pressedOpacity = 0.5
    
    let buttonStyle: TokenButtonStyle
    let buttonLabel: TokenButtonLabel
    
    //Text Button
    init(linkText: String){
        buttonLabel = TokenButtonLabel(linkText: linkText )
        buttonStyle = TokenButtonStyle(foregroundColor: Color.Token.linkText)
    }
    
    // Capsule Button
    init(capsuleText: String, size: ButtonSize ) {
        buttonLabel = TokenButtonLabel(text: capsuleText)
        buttonStyle = TokenButtonStyle(
            width: size.rawValue,
            bgColor: Color.Token.buttonPrimary,
            pressedOpacity: pressedOpacity
        )
    }
    
    enum IconSize: CGFloat{
        case medium = 20
        case large = 40
    }
    
    enum ButtonSize: CGFloat {
        case large = 280
        case medium = 182
    }
    
    enum CapsuleValue: CGFloat{
        case verticalPad = 20
        case cornerRadius = 30
    }
}

struct TokenButtonLabel: View {
    let name: String
    let iconSize: Image.Scale?
    let labelType: LabelTypes
    
    //Button Text
    init(text: String) {
        labelType = .text
        name = text
        iconSize = nil
    }
    
    //Link Text
    init(linkText: String) {
        labelType = .link
        name = linkText
        iconSize = nil
    }
    
    //System Icon
    init(systemName: String, iconSize: Image.Scale){
        labelType = .icon
        name = systemName
        self.iconSize = iconSize
    }
    
    func getView() -> some View {
        switch labelType {
        case .icon:
            return Image(systemName: name)
                .foregroundColor(.secondary)
                .imageScale(iconSize!)
                .frame(width: 44, height: 44, alignment: .topTrailing)
                .eraseToAnyView()
        case .text:
            return Text(name)
                .font(Font.Token.buttonFont)
                .eraseToAnyView()
        case .link:
            return Text(name)
                .font(Font.Token.linkFont)
                .eraseToAnyView()
        }
    }
    
    var body: some View {
        getView()
    }
    
    enum LabelTypes {
        case text, icon, link
    }
}

struct TokenButtonStyle: ButtonStyle{
    var width: CGFloat?
    var bgColor: Color?
    var pressedOpacity: Double?
    var foregroundColor: Color?
    var styleType: StyleType
    
    //Capsule
    init(width: CGFloat, bgColor: Color, pressedOpacity: Double){
        styleType = .capsule
        self.width = width
        self.bgColor = bgColor
        self.pressedOpacity = pressedOpacity
    }
    
    //Link
    init(foregroundColor: Color) {
        styleType = .link
        self.foregroundColor = foregroundColor
    }
    
    func makeBody(configuration: Configuration) -> some View {
        let verticalPad = TokenButton.CapsuleValue.verticalPad.rawValue
        let cornerRadius = TokenButton.CapsuleValue.cornerRadius.rawValue
            
        switch styleType {
        case .capsule:
            return configuration.label
                .padding(.vertical, verticalPad)
                .frame(width: width)
                .background(bgColor.opacity(
                    configuration.isPressed ? pressedOpacity! : 1
                ))
                .foregroundColor(Color.Token.buttonText)
                .cornerRadius(cornerRadius)
                .eraseToAnyView()
        case .link:
            return configuration.label
                .foregroundColor(foregroundColor)
                .eraseToAnyView()
        }
        
    }
    
    enum StyleType{
        case capsule, link
    }
}
