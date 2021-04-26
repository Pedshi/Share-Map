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

struct TokenColor {
    
    let buttonText: Color
    let linkText: Color
    let highlightBorder: Color
    let buttonPrimary: Color
    
    init(){
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

enum TokenImageName: String {
    case reading = "reading-by-tree"
    case standing = "standing"
}


extension Color {
   static let Token = TokenColor()
}

extension Font {
    static let Token = TokenFont()
}



enum Layout: CGFloat {
    case oneEight = 0.125
    case oneQuarter = 0.25
    case threeEights = 0.375
    case oneHalf = 0.5
    case fiveEights = 0.625
    case threeQuarters = 0.75
    case sevenEights = 0.875
    
    case oneTwentieth = 0.05
    case twoTwentieths = 0.1
    case threeTwentieths = 0.15
    case fourTwentieths = 0.2
    case sixTwentieths = 0.3
    case sevenTwentieths = 0.35
    case eightTwentieths = 0.4
}

enum Space: CGFloat{
    case times1 = 8.0
    case times2 = 16.0
    case times3 = 24.0
    case times4 = 32.0
    case times5 = 40.0
    case times6 = 48.0
    case times7 = 56.0
    case times8 = 64.0
}
