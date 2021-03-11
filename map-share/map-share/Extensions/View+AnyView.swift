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
