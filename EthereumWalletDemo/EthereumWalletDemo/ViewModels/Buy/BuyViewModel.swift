//
//  BuyViewModel.swift
//  EthereumWalletDemo
//
//  Created by LeonHan on 2022/8/8.
//

import SwiftUI

/// view model
class BuyViewModel: ObservableObject {
    /// all user data
    var accounts: [Account] {
        return PersistenceController.shared.allAccounts
    }
    var tokenAbbr: String = (EthereumNetworkService.priceDict.first?.key)!
    /// current user
    @Published var currentAccount = PersistenceController.shared.currentAccount
    /// for alertview
    @Published var showAlertFromViewModel = false
    /// for alertview
    @Published var alertMessage: String = ""
    @Published var tokenNumberString: String = "0"

    required init() {
        EthereumNetworkService().getPriceData {
            // Do nothing
        }
    }

    /// same as SendToViewModel
    func switchAccount(_ account: Account) {
        currentAccount = account
    }

    /// same as SendToViewModel
    func showAlert(message:String) {
        showAlertFromViewModel = true
        alertMessage = message
    }

    /// same as SendToViewModel
    func switchToken(name: String) -> (String, Double) {
        tokenAbbr = name
        return (name, EthereumNetworkService.priceDict[name] ?? 0)
    }

    /// add token to current account
    /// no fee is charged
    func buyToken() {
        let tokenNumber = Double(tokenNumberString) ?? 0.0
        if tokenNumber <= 0 {
            showAlert(message: "Please input a valid token number")
            return
        }

        if tokenNumber > 1000 {
            showAlert(message: "Token number should not exceed 1000")
            return
        }
        PersistenceController.shared.receive(tokenName: tokenAbbr, amount: tokenNumber)
        showAlert(message: "You have bought \(tokenNumber) \(tokenAbbr) for \(currentAccount?.name ?? "")")
    }
}
