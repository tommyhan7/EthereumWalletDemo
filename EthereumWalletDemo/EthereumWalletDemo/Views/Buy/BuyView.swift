//
//  BuyView.swift
//  EthereumWalletDemo
//
//  Created by LeonHan on 2022/8/8.
//

import SwiftUI

struct BuyView: View {
    private var selectedTokenAbbr: String = ""
    @ObservedObject var viewModel: BuyViewModel = BuyViewModel()
    
    @State private var showingSelectAccounts = false
    @State private var showingSelectTokens = false

    init(selectedTokenAbbr: String) {
        self.selectedTokenAbbr = selectedTokenAbbr
    }

    var body: some View {
        ZStack {
            ScrollView {
                Spacer().frame(width: .infinity, height: 30)
                HStack {
                    Text("Account:").font(.system(size: 14)).frame(minWidth: 60, alignment: .leading)

                    HStack {
                        Image(viewModel.currentAccount?.avatar ?? "")
                            .resizable().aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25)

                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.init(hex: 0x4595f4), lineWidth: 2))
                            .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))


                        VStack {
                            Text(viewModel.currentAccount?.name ?? "").font(.system(size: 14)).frame(maxWidth: .infinity, alignment: .leading)
                                .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))

                            Text(viewModel.currentAccount?.address ?? "").font(.system(size: 7)).frame(maxWidth: .infinity, alignment: .leading)
                                .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))

                        }

                        Spacer()

                        Image("Detail_Disclosure")
                            .resizable().aspectRatio(contentMode: .fit)
                            .frame(width: 12, height: 12)

                            .rotationEffect(.degrees(90))
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
                    }

                    .padding(EdgeInsets(top: 8, leading: 15, bottom: 8, trailing: 15))
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(lineWidth: 1.0)
                            .foregroundColor(Color.gray)

                    )

                    Spacer()
                }.padding(EdgeInsets(top: 0, leading: 25, bottom: 0, trailing: 0))
                    .contentShape(Rectangle())
                    .onTapGesture(perform: {
                        showingSelectAccounts = true
                    })
                    .confirmationDialog("Choose Account", isPresented: $showingSelectAccounts, titleVisibility: .visible) {
                        ForEach(viewModel.accounts, id: \.name) { userModel in
                            let nickName = userModel.name
                            Button(nickName ?? "") {
                                viewModel.switchAccount(userModel)
                            }
                        }
                    }

                HStack {
                    Text("Token:").font(.system(size: 14)).frame(minWidth: 60, alignment: .leading)

                    HStack {
                        Image(viewModel.tokenAbbr)
                            .resizable().aspectRatio(contentMode: .fit)
                            .frame(width: 25, height:25)

                            .clipShape(Circle())
                            .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))

                        VStack {
                            Text(viewModel.tokenAbbr).font(.system(size: 14)).frame(maxWidth: .infinity, alignment: .leading)
                                .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))
                            Text("\(EthereumNetworkService.priceDict[viewModel.tokenAbbr] ?? 0)").font(.system(size: 8)).frame(maxWidth: .infinity, alignment: .leading)
                                .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))
                        }
                        Spacer()
                        Image("Detail_Disclosure")
                            .resizable().aspectRatio(contentMode: .fit)
                            .frame(width: 12, height: 12)

                            .rotationEffect(.degrees(90))
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
                    }

                    .padding(EdgeInsets(top: 8, leading: 15, bottom: 8, trailing: 15))
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(lineWidth: 1.0)
                            .foregroundColor(Color.gray)

                    )
                    Spacer()
                }.padding(EdgeInsets(top: 25, leading: 25, bottom: 0, trailing: 0))
                    .contentShape(Rectangle())
                    .onTapGesture(perform: {
                        showingSelectTokens = true
                    })
                    .confirmationDialog("Choose Token", isPresented: $showingSelectTokens, titleVisibility: .visible) {
                        ForEach(EthereumNetworkService.priceDict.sorted(by: <), id: \.key) { key, value in
                            Button(key) {
                                viewModel.switchToken(name: key)
                            }
                        }
                    }
                HStack {
                    Text("Number:").font(.system(size: 14)).frame(minWidth: 60, alignment: .leading)

                    TextField("Number to send", text: $viewModel.tokenNumberString)
                        .textFieldStyle(.roundedBorder)
                        .font(.system(size:12))
                        .keyboardType(.decimalPad)
                    Spacer()
                }.padding(EdgeInsets(top: 25, leading: 25, bottom: 0, trailing: 0))
                Spacer()
            }

            GeometryReader { geometry in
                ZStack {
                    VStack(alignment: .center, spacing: 10, content: {
                        Spacer()
                        Button(action: {
                            viewModel.buyToken()
                        }) {
                            Text("Buy").font(.system(size: 20))
                                .foregroundColor(.white)
                        }
                        .frame(width: 200, height: 50, alignment: .center)
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(EdgeInsets(top: 0, leading: 40, bottom: 25, trailing: 40))
                    })
                }
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
        .navigationBarTitle("Buy", displayMode: .inline)
        .navigationViewStyle(StackNavigationViewStyle())
        .alert(isPresented: $viewModel.showAlertFromViewModel) {
            Alert(title: Text("Notice"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("Close"), action: {
            }))
        }
        .contentShape(Rectangle())
        .onTapGesture {
            hideKeyboard()
        }
        .onAppear() {
        }
    }
}

struct BuyView_Previews: PreviewProvider {
    static var previews: some View {
        BuyView(selectedTokenAbbr: "")
    }
}
