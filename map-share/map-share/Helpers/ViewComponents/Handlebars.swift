//
//  Handlebars.swift
//  map-share
//
//  Created by Pedram Shirmohammad on 2021-03-31.
//

import SwiftUI

@frozen public struct Handlebar: View {
    public var body: some View {
        Capsule()
            .fill(Color(UIColor.lightGray))
            .frame(width: 30, height: 3)
            .padding(Pad.medium.rawValue)
    }
}
