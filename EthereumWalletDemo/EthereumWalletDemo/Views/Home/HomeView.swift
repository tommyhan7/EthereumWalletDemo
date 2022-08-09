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

    @State private var showingSelectAccounts = false
    @State private var navigateToSend = false
    @State private var selectedTokenAbbr = "";
    @State private var shouldNavigateToTokenPage = false;

//    var destination : some View {
//        return TokenPageView(selectedTokenAbbr: selectedTokenAbbr)
//    }

    var body: some View {
        NavigationView {
            List {
                HomeHeaderView()
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
            viewModel.fetchPrice()
        }) {
            Image("Refresh")
                .resizable().aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 20).disabled(viewModel.isFetchingPrice)
        })
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}
