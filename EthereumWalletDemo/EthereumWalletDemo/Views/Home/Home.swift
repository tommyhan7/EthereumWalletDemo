//
//  Home.swift
//  EthereumWalletDemo
//
//  Created by LeonHan on 2022/8/8.
//

import SwiftUI

struct Home: View {
    @Environment(\.colorScheme) var colorScheme

    @StateObject var viewModel: HomeViewModel = HomeViewModel()

    @State private var showingSelectAccounts = false
    @State private var navigateToSend = false
    @State private var selectedTokenAbbr = "";
    @State private var shouldNavigateToTokenPage = false;

//    var destination : some View {
//        return TokenPageView(selectedTokenAbbr: selectedTokenAbbr)
//    }

    var body: some View {
//        Text("Hello")
//        let userModel = viewModel.userModel!;
//        let walletAddress = userModel.walletAddress;
//        let index = walletAddress.index(walletAddress.endIndex, offsetBy: -4);
//        let address = "\(walletAddress.prefix(6))..\(walletAddress.suffix(from: index))";
//        let tokens = userModel.tokens;
//        let userModels = viewModel.userModels;

        let currentAccount = viewModel.accounts
        NavigationView {
            List {
                HomeHeader()
                ForEach(viewModel.accounts) { account in
                    NavigationLink {
                        Text("Item at \(account.name!)")
                    } label: {
                        Text(account.name!)
                    }
                }
                .onDelete(perform: viewModel.deleteToken)
            }
            .listStyle(.plain)
            Text("Select an item")
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text("Wallet")
                    Text("subtitle")
                }
            }
        }
        .navigationBarItems(trailing: Button(action: {
            viewModel.fetchPrice()
        }) {
            Image("Refresh")
                .resizable().aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 20).disabled(viewModel.fetchingPriceData)
        })

        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
