//
//  HomeView.swift
//  EthereumWalletDemo
//
//  Created by LeonHan on 2022/8/8.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.colorScheme) var colorScheme

    @StateObject var viewModel: HomeViewModel = HomeViewModel()

    @State private var isShowingSelectAccounts = false
    @State private var navigateToSend = false
    @State private var selectedTokenAbbr = ""
    @State private var shouldNavigateToTokenPage = false

    private var tokens: [Token] {
        if let tokens = viewModel.persistenceController.currentAccount?.tokens {
            return Array.init(_immutableCocoaArray: tokens)
        } else {
            return []
        }
    }

    var body: some View {
        NavigationView {
            List {
                HomeHeaderView(isPresenting: $isShowingSelectAccounts)
                ForEach(tokens) { token in
                    NavigationLink {
                        Text("Item at \(token.name!)")
                    } label: {
                        Text(token.name!)
                    }
                }
            }
            .listStyle(.plain)
            Text("Select an item")
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text("Wallet")
                    HStack {
                        Circle()
                            .size(width: 3, height: 3)
                            .foregroundColor(.green)
                        Spacer(minLength: 6)
                        Text("Ethereum Mainnet")
                    }
                }
            }
        }
        .navigationBarItems(trailing: Button(action: {
            viewModel.fetchPrice { priceDict in
                // Do nothing
            }
        }) {
            Image("Refresh")
                .resizable().aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 20).disabled(viewModel.isFetchingPrice)
        })
        .navigationViewStyle(StackNavigationViewStyle())
        .toast(isShow: $viewModel.isShowingToast, info:  viewModel.toastMessage, duration: 1)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}
