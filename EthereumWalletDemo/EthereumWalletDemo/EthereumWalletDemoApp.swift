//
//  EthereumWalletDemoApp.swift
//  EthereumWalletDemo
//
//  Created by LeonHan on 2022/8/8.
//

import SwiftUI

@main
struct EthereumWalletDemoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
