//
//  View+AnyView.swift
//  map-share
//
//  Created by Pedram Shirmohammad on 2021-03-11.
//

import Foundation
import SwiftUI

extension View {
    func eraseToAnyView() -> AnyView { AnyView(self) }
}

extension View {
    func inputLabel() -> some View {
        self
            .modifier(InputLabel())
    }
}

struct InputLabel: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.body.weight(.semibold))
            .padding(.leading, 26)
            .padding(.bottom, -5)
    }
}

private extension ButtonStyle {
    var verticalPad: CGFloat { 20 }
    var pressedOpacity: Double { 0.5 }
    var cornerRadius: CGFloat { 30 }
    var textColor: Color { .white }
    var textFont: Font { Font.body.weight(.semibold) }
}

struct ActionButton: ButtonStyle {
    var width : CGFloat
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .font(textFont)
            .padding(.vertical, verticalPad)
            .frame(width: width)
            .background(Color.Token.buttonPrimary.opacity(
                configuration.isPressed ? pressedOpacity : 1
            ))
            .foregroundColor(textColor)
            .cornerRadius(cornerRadius)
    }
}

struct SingleTextFieldStyle: TextFieldStyle{
    var width : CGFloat
    func _body(configuration: TextField<_Label>) -> some View {
        configuration
            .padding(18)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.Token.highlightBorder, lineWidth: 1)
            )
            .frame(width: width)
    }
}

extension Image {
    func fitResize(width: CGFloat? = nil, height: CGFloat? = nil) -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: width, height: height)
    }
}

extension View {
    func fullScreen(alignment: Alignment) -> some View {
        self
            .frame(
                minWidth: 0, maxWidth: .infinity,
                minHeight: 0, maxHeight: .infinity,
                alignment: alignment
            )
    }
}
