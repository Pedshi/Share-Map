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

    init() {
        
    }
    
    var body: some Scene {
        WindowGroup {
//            HomeView(homeVM: HomeViewModel())
            LoginView(viewModel: LoginViewModel())
                //.environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
