//
//  TokenViewModel.swift
//  EthereumWalletDemo
//
//  Created by LeonHan on 2022/8/8.
//

import SwiftUI

/// viewModel for token page
class TokenViewModel: ObservableObject {
    /// all user data
    var accounts: [Account] {
        return PersistenceController.shared.allAccounts
    }
    /// current user
    @Published var currentAccount = PersistenceController.shared.currentAccount
}
