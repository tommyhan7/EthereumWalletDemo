//
//  HomeViewModel.swift
//  EthereumWalletDemo
//
//  Created by LeonHan on 2022/8/8.
//

import SwiftUI

class HomeViewModel: ObservableObject {
    @Environment(\.managedObjectContext) private var viewContext

    @Published var isShowingToast = false
    @Published var isFetchingPrice = false
    @Published var toastMessage = ""
    
    let ethereumNetworkService = EthereumNetworkService.init()
    let persistenceController = PersistenceController.shared

    init() {
        ethereumNetworkService.startService()
    }

    func fetchPrice(completion: @escaping ([String: Double]) -> Void) {
        isFetchingPrice = true
        let service = EthereumNetworkService()
        service.startService()
        service.getPriceData {
            completion(EthereumNetworkService.priceDict)
            self.objectWillChange.send()
            self.isFetchingPrice = false
        }
    }

    func copyAddressToClipBoard() {
        let pasteBoard = UIPasteboard.general
        pasteBoard.string = PersistenceController.shared.currentAccount?.address

        self.isShowingToast = true
        self.toastMessage = "Address has been copied to pasteboard!"
    }
}
