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
            var tokenArray: [Token] = []
            _ = tokens.map {
                if let token = $0 as? Token {
                    tokenArray.append(token)
                }
            }
            return tokenArray.sorted { prev, next in
                prev.name ?? "" < next.name ?? ""
            }
        } else {
            return []
        }
    }

    var body: some View {
        NavigationView {
            ScrollView {
                HomeHeaderView(isPresenting: $isShowingSelectAccounts)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                ForEach(tokens) { tokenModel in
                    HStack {
                        Image(tokenModel.name ?? "")
                            .resizable().aspectRatio(contentMode: .fit)
                            .frame(width: 30, height:30)

                            .clipShape(Circle())
                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                        VStack {
                            Text("\(tokenModel.quantity) \(tokenModel.name ?? "")").font(.system(size: 12))
                                .padding(EdgeInsets(top: 3, leading: 0, bottom: 3, trailing: 0))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("\(viewModel.persistenceController.value(of: tokenModel.name ?? ""))").font(.system(size: 12)).frame(maxWidth: .infinity, alignment: .leading)

                        }
                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))

                        Spacer()

                        Image("right-arrow")
                            .resizable().aspectRatio(contentMode: .fit)
                            .frame(width: 60, height: 60)
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedTokenAbbr = tokenModel.name ?? ""
                        shouldNavigateToTokenPage = true
                    }

                    Divider()
                }
            }
            .toast(isShow: $viewModel.isShowingToast, info:  viewModel.toastMessage, duration: 1)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack(alignment: .center, spacing: 3, content: {
                        Text("Wallet")
                            .font(.system(size: 18, weight: .semibold, design: Font.Design.default))
                        HStack {
                            Circle()
                                .size(width: 5, height: 5)
                                .foregroundColor(.green)
                                .allowsTightening(true)
                            Text("Ethereum Mainnet")
                                .font(.system(size: 12, weight: .regular, design: Font.Design.default))
                        }
                    })
                }

                ToolbarItem {
                    Button(action: {
                        viewModel.fetchPrice { priceDict in
                            // Do nothing
                        }
                    }) {
                        Image("Refresh")
                            .resizable().aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20).disabled(viewModel.isFetchingPrice)
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}
