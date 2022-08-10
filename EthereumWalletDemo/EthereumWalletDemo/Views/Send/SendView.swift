//
//  SendView.swift
//  EthereumWalletDemo
//
//  Created by LeonHan on 2022/8/8.
//

import SwiftUI

struct SendView: View {
    private var selectedTokenAbbr: String = ""
    @ObservedObject var viewModel: SendViewModel = SendViewModel()
    
    @State private var showingSelectAccounts = false
    @State private var showingSelectTokens = false
    @State private var showingSelectAccountsForAddress = false
    
    init(selectedTokenAbbr: String) {
        self.selectedTokenAbbr = selectedTokenAbbr
    }

    var body: some View {
        Text("Hello")
    }
}

struct SendView_Previews: PreviewProvider {
    static var previews: some View {
        SendView(selectedTokenAbbr: "")
    }
}
