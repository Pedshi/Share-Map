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
