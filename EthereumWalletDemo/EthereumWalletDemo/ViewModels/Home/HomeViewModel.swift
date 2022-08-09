//
//  HomeViewModel.swift
//  EthereumWalletDemo
//
//  Created by LeonHan on 2022/8/8.
//

import SwiftUI

class HomeViewModel: ObservableObject {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Account.name, ascending: true)],
        animation: .default)
    var accounts: FetchedResults<Account>

    @Published var isFetchingPrice = false

    func fetchPrice(){
        isFetchingPrice = true
        let service = EthereumNetworkService()
        service.startService()
        service.getPriceData {
            self.objectWillChange.send()
            self.isFetchingPrice = false
        }
    }

    func deleteToken(offsets: IndexSet) {
        withAnimation {
            offsets.map { accounts[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
