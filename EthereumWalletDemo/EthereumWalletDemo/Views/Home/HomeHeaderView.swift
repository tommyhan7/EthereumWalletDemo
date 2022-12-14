//
//  HomeHeaderView.swift
//  EthereumWalletDemo
//
//  Created by LeonHan on 2022/8/8.
//

import SwiftUI

struct HomeHeaderView: View {
    @Binding var isPresenting: Bool
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var viewModel: HomeViewModel = HomeViewModel()

    var body: some View {
        VStack {
            VStack {
                Image(viewModel.persistenceController.currentAccount?.avatar ?? "")
                    .resizable().aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.init(hex: 0x4595f4), lineWidth: 2))
                    .onTapGesture(perform: {
                        isPresenting = true
                    })
                    .confirmationDialog("Switch Account", isPresented: $isPresenting, titleVisibility: .visible) {
                        ForEach(PersistenceController.shared.allAccounts) { account in
                            let nickName = account.name
                            Button(nickName ?? "") {
                                PersistenceController.shared.change(to: account)
                            }
                        }
                    }
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))

                Text(viewModel.persistenceController.currentAccount?.name ?? "").font(.headline)
                    .contentShape(Rectangle())
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))

                Text(viewModel.totalValueString).font(.system(size: 12))
                    .padding(EdgeInsets(top: 3, leading: 0, bottom: 0, trailing: 0))

                Text(viewModel.trimmedAddress).font(.system(size: 12))
                    .padding(EdgeInsets(top: 8, leading: 15, bottom: 8, trailing: 15))
                    .background(colorScheme == .dark ? Color.init(hex: 0x263748) : Color.init(hex: 0xe8f2fb))
                    .clipShape(Capsule())
                    .padding(EdgeInsets(top: 10, leading: 100, bottom: 0, trailing: 100))
                    .lineLimit(1)
                    .onTapGesture {
                        viewModel.copyAddressToClipBoard()
                    }
            }

            HStack {
                NavigationLink(
                    destination: BuyView(selectedTokenAbbr: "")
                ) {
                    VStack {
                        Image("Buy")
                            .resizable().aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                            .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                        Text("Buy").font(.system(size: 12))
                            .foregroundColor(Color.init(hex: 0x387ace))
                            .padding(EdgeInsets(top: 3, leading: 0, bottom: 0, trailing: 0))
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6))
                NavigationLink(
                    destination: SendView(selectedTokenAbbr: "")
                ) {
                    VStack {
                        Image("Send")
                            .resizable().aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                            .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))

                        Text("Send").font(.system(size: 12))
                            .foregroundColor(Color.init(hex: 0x387ace))
                            .padding(EdgeInsets(top: 3, leading: 0, bottom: 0, trailing: 0))
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6))
            }
            .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))

            Text("TOKENS").font(.system(size: 12))
                .fontWeight(.bold)
                .foregroundColor(Color.init(hex: 0x387ace))
                .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))

            Rectangle()
                .fill(Color.init(hex: 0x387ace))
                .frame(height: 2)
        }
    }
}

struct HomeHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HomeHeaderView(isPresenting: Binding<Bool>.init(get: {
            false
        }, set: { isPresenting in
            // Do nothing
        }))
    }
}
