//
//  map_shareApp.swift
//  map-share
//
//  Created by Pedram Shirmohammad on 2021-03-08.
//

import SwiftUI

@main
struct map_shareApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            LoginView(viewModel: LoginViewModel())
                //.environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
