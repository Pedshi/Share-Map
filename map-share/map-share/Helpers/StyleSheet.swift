//
//  StyleSheet.swift
//  map-share
//
//  Created by Pedram Shirmohammad on 2021-03-29.
//

import Foundation
import SwiftUI

enum AnimationDurr: Double{
    case short = 0.3
    case medium = 0.5
    case long = 0.8
}

enum RadiusSize: CGFloat {
    case small = 10
    case large = 20
}

enum Pad: CGFloat{
    case small = 5
    case medium = 10
    case large1 = 20
    case large = 25
}

enum VSpace: CGFloat{
    case small = 20
    case medium = 40
}






struct TokenColor {
    let backgroundDefault: Color
    
    let buttonText: Color
    let linkText: Color
    let highlightBorder: Color
    let buttonPrimary: Color
    
    init(){
        backgroundDefault = Color("bg-color")
        buttonText = .white
        linkText = Color("primary-color")
        buttonPrimary = Color("primary-color")
        highlightBorder = Color("border-color")
    }
}

struct TokenFont {
    let inputHint: Font
    let buttonFont: Font
    let linkFont: Font
    
    init(){
        inputHint = Font.body.weight(.semibold)
        buttonFont = Font.body.weight(.semibold)
        linkFont = Font.body.weight(.regular)
    }
}

extension Color {
   static let Token = TokenColor()
}

extension Font {
    static let Token = TokenFont()
}


struct TokenButton {
    
    let pressedOpacity = 0.5
    
    let buttonStyle: TokenButtonStyle
    let buttonLabel: TokenButtonLabel
    
    init(buttonText: String, size: ButtonSize ) {
        buttonLabel = TokenButtonLabel(text: buttonText)
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
        case large = 180
        case medium = 80
    }
    
//    enum CapsuleSize{
//        case medium, large
//        
//        func getValue() -> CGFloat {
//            switch self {
//            case .large:
//                return ButtonSize.large.rawValue
//            case .medium:
//                return ButtonSize.medium.rawValue
//            }
//        }
//    }
    
    enum CapsuleValue: CGFloat{
        case verticalPad = 20
        case cornerRadius = 30
    }
}

struct TokenButtonLabel: View {
    let name: String
    let iconSize: TokenButton.ButtonSize?
    let labelType: LabelTypes
    
    init(text: String) {
        labelType = .text
        name = text
        iconSize = nil
    }
    
    init(text: String, iconSize: TokenButton.ButtonSize){
        labelType = .icon
        name = text
        self.iconSize = iconSize
    }
    
    func getView() -> some View {
        switch labelType {
        case .icon:
            return Image(systemName: name).eraseToAnyView()
        case .text:
            return Text(name)
                    .font(Font.Token.buttonFont).eraseToAnyView()
        }
    }
    
    var body: some View {
        getView()
    }
    
    enum LabelTypes {
        case text, icon
    }
}

struct TokenButtonStyle: ButtonStyle{
    var width: CGFloat
    var bgColor: Color
    var pressedOpacity: Double
    
    func makeBody(configuration: Configuration) -> some View {
        let verticalPad = TokenButton.CapsuleValue.verticalPad.rawValue
        let cornerRadius = TokenButton.CapsuleValue.cornerRadius.rawValue
            
        return configuration.label
                .padding(.vertical, verticalPad)
                .frame(width: width)
                .background(bgColor.opacity(
                    configuration.isPressed ? pressedOpacity : 1
                ))
                .foregroundColor(Color.Token.buttonText)
                .cornerRadius(cornerRadius)
    }
}

//struct TokenButtonStyle: ButtonStyle {
//    var width: CGFloat
//
//
//
//    func makeBody(configuration: Configuration) -> some View {
//        <#code#>
//    }
//}

//private extension ButtonStyle {
//    var verticalPad: CGFloat { 20 }
//    var pressedOpacity: Double { 0.5 }
//    var cornerRadius: CGFloat { 30 }
//    var textColor: Color { .white }
//    var textFont: Font { Font.body.weight(.semibold) }
//}
//struct ActionButton: ButtonStyle {
//    var width : CGFloat
//    func makeBody(configuration: Configuration) -> some View {
//        configuration
//            .label
//            .font(textFont)
//            .padding(.vertical, verticalPad)
//            .frame(width: width)
//            .background(Color.Token.buttonPrimary.opacity(
//                configuration.isPressed ? pressedOpacity : 1
//            ))
//            .foregroundColor(textColor)
//            .cornerRadius(cornerRadius)
//    }
//}
