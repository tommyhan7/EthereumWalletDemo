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
    private var selectedTokenCount: Double = 0

    @StateObject var viewModel: TokenViewModel = TokenViewModel()
    /// show actionsheet for selecting accounts
    @State private var showingSelectAccounts = false
    /// navigate to send page
    @State private var navigateToSend = false
    
    init(selectedTokenAbbr: String, selectedTokenCount: Double) {
        self.selectedTokenAbbr = selectedTokenAbbr
        self.selectedTokenCount = selectedTokenCount
    }

    var body: some View {
        ScrollView {
            Image(selectedTokenAbbr)
                .resizable().aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)

                .clipShape(Circle())

                .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))

            Text("\(selectedTokenCount) \(selectedTokenAbbr)")
                .font(.system(size: 20))
                .fontWeight(.bold)
                .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))


            Text("$\(PersistenceController.shared.value(of: selectedTokenAbbr))").font(.system(size: 16))
                .padding(EdgeInsets(top: 3, leading: 0, bottom: 0, trailing: 0))
            HStack {
                NavigationLink(
                    destination: SendView(selectedTokenAbbr: selectedTokenAbbr)
                ){
                    VStack {
                        Image("Send")
                            .resizable().aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)

                            .clipShape(Circle())
                            .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                        Text("Send").font(.system(size: 12))
                            .foregroundColor(Color.init(hex: 0x387ace))
                            .padding(EdgeInsets(top: 3, leading: 0, bottom: 0, trailing: 0))

                    }
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 15))

                }
                NavigationLink(
                    destination: BuyView(selectedTokenAbbr: selectedTokenAbbr)
                ){
                    VStack{
                        Image("Buy")
                            .resizable().aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                            .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                        Text("Buy").font(.system(size: 12))
                            .foregroundColor(Color.init(hex: 0x387ace))
                            .padding(EdgeInsets(top: 3, leading: 0, bottom: 0, trailing: 0))
                    }
                }

            }
            .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
        }.navigationBarTitle(selectedTokenAbbr, displayMode: .inline)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct TokenView_Previews: PreviewProvider {
    static var previews: some View {
        TokenView(selectedTokenAbbr:"BTC", selectedTokenCount: 14)
    }
}
