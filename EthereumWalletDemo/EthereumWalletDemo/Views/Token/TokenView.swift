//
//  TokenView.swift
//  EthereumWalletDemo
//
//  Created by LeonHan on 2022/8/8.
//

import SwiftUI

struct TokenView: View {
    /// param passed from last page in navigator stack
    private var selectedTokenAbbr: String = ""

    @StateObject var viewModel: TokenViewModel = TokenViewModel()
    /// show actionsheet for selecting accounts
    @State private var showingSelectAccounts = false
    /// navigate to send page
    @State private var navigateToSend = false
    
    init(selectedTokenAbbr: String) {
        self.selectedTokenAbbr = selectedTokenAbbr
    }

//    var body: some View {
//        let tokenModel = viewModel.tokenModel
//
//        ScrollView {
//            Image(tokenModel?.abbr ?? "")
//                .resizable().aspectRatio(contentMode: .fit)
//                .frame(width: UIHelper.getUIElementSizeByDesignWidth(designedWidth: 150), height: UIHelper.getUIElementSizeByDesignWidth(designedWidth: 150))
//
//                .clipShape(Circle())
//
//                .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
//
//            Text("\(tokenModel?.count ?? 0) \(tokenModel?.abbr ?? "")")
//                .font(.system(size: 20))
//                .fontWeight(.bold)
//                .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
//
//
//            //TODO: change total amount
//            Text(tokenModel?.dollarPriceString ?? "$0").font(.system(size: 16))
//                .padding(EdgeInsets(top: 3, leading: 0, bottom: 0, trailing: 0))
//            HStack {
//                NavigationLink(
//                    destination: SendToView(selectedTokenAbbr: tokenModel?.abbr ?? "")
//                ){
//                    VStack {
//                        Image("send")
//                            .resizable().aspectRatio(contentMode: .fit)
//                            .frame(width: UIHelper.getUIElementSizeByDesignWidth(designedWidth: 150), height: UIHelper.getUIElementSizeByDesignWidth(designedWidth: 150))
//
//                            .clipShape(Circle())
//                            .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
//                        Text("Send").font(.system(size: 12))
//                            .foregroundColor(UIHelper.themeColor)
//                            .padding(EdgeInsets(top: 3, leading: 0, bottom: 0, trailing: 0))
//
//                    }
//                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 15))
//
//                }
//                NavigationLink(
//                    destination: BuyView(selectedTokenAbbr: tokenModel?.abbr ?? "")
//                ){
//                    VStack{
//                        Image("buy")
//                            .resizable().aspectRatio(contentMode: .fit)
//                            .frame(width: UIHelper.getUIElementSizeByDesignWidth(designedWidth: 150), height: UIHelper.getUIElementSizeByDesignWidth(designedWidth: 150))
//
//                            .clipShape(Circle())
//                            .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
//                        Text("Buy").font(.system(size: 12))
//                            .foregroundColor(UIHelper.themeColor)
//                            .padding(EdgeInsets(top: 3, leading: 0, bottom: 0, trailing: 0))
//
//
//                    }
//                }
//
//            }
//            .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
//        }.navigationBarTitle(viewModel.tokenModel?.abbr ?? "", displayMode: .inline)
//        .navigationViewStyle(StackNavigationViewStyle())
//        .onAppear(){
//            viewModel.updateTokenAbbr(selectedTokenAbbr:self.selectedTokenAbbr)
//        }
//    }

    var body: some View {
        Text("Hello")
    }
}

struct TokenView_Previews: PreviewProvider {
    static var previews: some View {
        TokenView(selectedTokenAbbr:"BTC")
    }
}
