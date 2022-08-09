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
                .padding(100)
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
//            ScrollView {
//                Image(userModel.iconName)
//                    .resizable().aspectRatio(contentMode: .fit)
//                    .frame(width: UIHelper.getUIElementSizeByDesignWidth(designedWidth: 150), height: UIHelper.getUIElementSizeByDesignWidth(designedWidth: 150))
//
//                    .clipShape(Circle())
//                    .overlay(Circle().stroke(Color.init(hex: 0x4595f4), lineWidth: 2))
//                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
//
//                HStack {
//                    Text(userModel.nickname).font(.headline)
//                        .contentShape(Rectangle())
//                        .onTapGesture(perform: {
//                            showingSelectAccounts = true;
//                        })
//                        .confirmationDialog("Switch Account", isPresented: $showingSelectAccounts, titleVisibility: .visible) {
//                            ForEach(userModels) { (userModel_: UserModel?) in
//                                if (userModel_ != nil) {
//                                    let nickName = userModel_!.nickname;
//                                    Button(nickName){
//                                        viewModel.switchAccount(id: userModel_!.id)
//                                    }
//                                }
//                            }
//                        }
//                        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
//
//                    Image("right-arrow")
//                        .resizable().aspectRatio(contentMode: .fit)
//                        .frame(width: 12, height: 12)
//                        .padding(EdgeInsets(top: 0, leading: 2, bottom: 0, trailing: 0))
//                }
//                .padding(EdgeInsets(top: 15, leading: 0, bottom: 0, trailing: 0))
//
//                Text(userModel.dollarPriceString).font(.system(size: 12))
//                    .padding(EdgeInsets(top: 3, leading: 0, bottom: 0, trailing: 0))
//
//                Text(address).font(.system(size: 12))
//                    .padding(EdgeInsets(top: 8, leading: 15, bottom: 8, trailing: 15))
//                    .background(colorScheme == .dark ? Color.init(hex: 0x263748) : Color.init(hex: 0xe8f2fb))
//                    .clipShape(Capsule())
//                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
//                    .onTapGesture {
//                        viewModel.copyAddressToClipBoard()
//                    }
//
//                HStack {
//                    NavigationLink(
//                        destination: SendToView(selectedTokenAbbr: "")
//                    ) {
//                        VStack {
//                            Image("send")
//                                .resizable().aspectRatio(contentMode: .fit)
//                                .frame(width: UIHelper.getUIElementSizeByDesignWidth(designedWidth: 150), height: UIHelper.getUIElementSizeByDesignWidth(designedWidth: 150))
//                                .clipShape(Circle())
//                                .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
//
//                            Text("Send").font(.system(size: 12))
//                                .foregroundColor(UIHelper.themeColor)
//                                .padding(EdgeInsets(top: 3, leading: 0, bottom: 0, trailing: 0))
//                        }
//                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 15))
//                    }
//
//                    NavigationLink(
//                        destination: BuyView(selectedTokenAbbr: "")
//                    ) {
//                        VStack {
//                            Image("buy")
//                                .resizable().aspectRatio(contentMode: .fit)
//                                .frame(width: UIHelper.getUIElementSizeByDesignWidth(designedWidth: 150), height: UIHelper.getUIElementSizeByDesignWidth(designedWidth: 150))
//                                .clipShape(Circle())
//                                .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
//                            Text("Buy").font(.system(size: 12))
//                                .foregroundColor(UIHelper.themeColor)
//                                .padding(EdgeInsets(top: 3, leading: 0, bottom: 0, trailing: 0))
//                        }
//                    }
//                }
//                .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
//
//                Text("TOKENS").font(.system(size: 12))
//                    .fontWeight(.bold)
//                    .foregroundColor(UIHelper.themeColor)
//                    .padding(EdgeInsets(top: 3, leading: 0, bottom: 0, trailing: 0))
//
//                Rectangle()
//                    .fill(UIHelper.themeColor)
//                    .frame(height: 2)
//
//                ForEach(tokens) { (tokenModel: TokenModel) in
//                    HStack {
//                        Image(tokenModel.abbr)
//                            .resizable().aspectRatio(contentMode: .fit)
//                            .frame(width: 30, height:30)
//
//                            .clipShape(Circle())
//                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
//
//                        VStack {
//                            Text("\(tokenModel.count) \(tokenModel.abbr)").font(.system(size: 12))
//                                .padding(EdgeInsets(top: 3, leading: 0, bottom: 3, trailing: 0))
//                                .frame(maxWidth: .infinity, alignment: .leading)
//
//                            Text(tokenModel.dollarPriceString ).font(.system(size: 12)).frame(maxWidth: .infinity, alignment: .leading)
//                        }
//                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
//
//                        Spacer()
//
//                        Image("right-arrow")
//                            .resizable().aspectRatio(contentMode: .fit)
//                            .frame(width: UIHelper.getUIElementSizeByDesignWidth(designedWidth: 60), height: UIHelper.getUIElementSizeByDesignWidth(designedWidth: 60))
//                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
//                    }
//                    .contentShape(Rectangle())
//                    .onTapGesture {
//                        selectedTokenAbbr = tokenModel.abbr
//                        shouldNavigateToTokenPage = true
//                    }
//
//                    Divider()
//                }
//
//                NavigationLink(
//                    destination: destination,
//                    isActive: $shouldNavigateToTokenPage
//
//                ) {
//                    EmptyView()
//                }
//            }
//            .navigationBarTitle("Wallet", displayMode: .inline)
//                .toast(isShow: $viewModel.showToast,  info:  viewModel.toastMessage, duration: 1)
//                .navigationBarItems(trailing: Button(action: {
//                    viewModel.fetchPrice()
//                }) {
//                    Image("refresh")
//                        .resizable().aspectRatio(contentMode: .fit)
//                        .frame(width: 20, height: 20).disabled(viewModel.fetchingPriceData)
//                })
//        }
//        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
