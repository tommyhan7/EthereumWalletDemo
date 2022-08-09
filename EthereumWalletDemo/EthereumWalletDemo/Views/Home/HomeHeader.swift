//
//  HomeHeader.swift
//  EthereumWalletDemo
//
//  Created by LeonHan on 2022/8/8.
//

import SwiftUI

struct HomeHeader: View {
    @Environment(\.managedObjectContext) private var viewContext

    @StateObject var viewModel: HomeViewModel = HomeViewModel()

    var body: some View {
        VStack {
            Image(userModel.iconName)
                .resizable().aspectRatio(contentMode: .fit)
                .frame(width: UIHelper.getUIElementSizeByDesignWidth(designedWidth: 150), height: UIHelper.getUIElementSizeByDesignWidth(designedWidth: 150))

                .clipShape(Circle())
                .overlay(Circle().stroke(Color.init(hex: 0x4595f4), lineWidth: 2))
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))

            Text(userModel.nickname).font(.headline)
                .contentShape(Rectangle())
                .onTapGesture(perform: {
                    showingSelectAccounts = true;
                })
                .confirmationDialog("Switch Account", isPresented: $showingSelectAccounts, titleVisibility: .visible) {
                    ForEach(userModels) { (userModel_: UserModel?) in
                        if (userModel_ != nil) {
                            let nickName = userModel_!.nickname;
                            Button(nickName){
                                viewModel.switchAccount(id: userModel_!.id)
                            }
                        }
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))

            Text(userModel.dollarPriceString).font(.system(size: 12))
                .padding(EdgeInsets(top: 3, leading: 0, bottom: 0, trailing: 0))

            Text(address).font(.system(size: 12))
                .padding(EdgeInsets(top: 8, leading: 15, bottom: 8, trailing: 15))
                .background(colorScheme == .dark ? Color.init(hex: 0x263748) : Color.init(hex: 0xe8f2fb))
                .clipShape(Capsule())
                .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                .onTapGesture {
                    viewModel.copyAddressToClipBoard()
                }
        }

        HStack {
            NavigationLink(
                destination: SendToView(selectedTokenAbbr: "")
            ) {
                VStack {
                    Image("Send")
                        .resizable().aspectRatio(contentMode: .fit)
                        .frame(width: UIHelper.getUIElementSizeByDesignWidth(designedWidth: 150), height: UIHelper.getUIElementSizeByDesignWidth(designedWidth: 150))
                        .clipShape(Circle())
                        .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))

                    Text("Receive").font(.system(size: 12))
                        .foregroundColor(UIHelper.themeColor)
                        .padding(EdgeInsets(top: 3, leading: 0, bottom: 0, trailing: 0))
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 15))
            }

            NavigationLink(
                destination: BuyView(selectedTokenAbbr: "")
            ) {
                VStack {
                    Image("Buy")
                        .resizable().aspectRatio(contentMode: .fit)
                        .frame(width: UIHelper.getUIElementSizeByDesignWidth(designedWidth: 150), height: UIHelper.getUIElementSizeByDesignWidth(designedWidth: 150))
                        .clipShape(Circle())
                        .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                    Text("Buy").font(.system(size: 12))
                        .foregroundColor(UIHelper.themeColor)
                        .padding(EdgeInsets(top: 3, leading: 0, bottom: 0, trailing: 0))
                }
            }

            NavigationLink(
                destination: SendToView(selectedTokenAbbr: "")
            ) {
                VStack {
                    Image("Send")
                        .resizable().aspectRatio(contentMode: .fit)
                        .frame(width: UIHelper.getUIElementSizeByDesignWidth(designedWidth: 150), height: UIHelper.getUIElementSizeByDesignWidth(designedWidth: 150))
                        .clipShape(Circle())
                        .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))

                    Text("Send").font(.system(size: 12))
                        .foregroundColor(UIHelper.themeColor)
                        .padding(EdgeInsets(top: 3, leading: 0, bottom: 0, trailing: 0))
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 15))
            }

            NavigationLink(
                destination: BuyView(selectedTokenAbbr: "")
            ) {
                VStack {
                    Image("Swap")
                        .resizable().aspectRatio(contentMode: .fit)
                        .frame(width: UIHelper.getUIElementSizeByDesignWidth(designedWidth: 150), height: UIHelper.getUIElementSizeByDesignWidth(designedWidth: 150))
                        .clipShape(Circle())
                        .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                    Text("Swap").font(.system(size: 12))
                        .foregroundColor(UIHelper.themeColor)
                        .padding(EdgeInsets(top: 3, leading: 0, bottom: 0, trailing: 0))
                }
            }
        }
        .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))

        Text("TOKENS").font(.system(size: 12))
            .fontWeight(.bold)
            .foregroundColor(UIHelper.themeColor)
            .padding(EdgeInsets(top: 3, leading: 0, bottom: 0, trailing: 0))

        Rectangle()
            .fill(UIHelper.themeColor)
            .frame(height: 2)
    }
}

struct HomeHeader_Previews: PreviewProvider {
    static var previews: some View {
        HomeHeader()
    }
}
