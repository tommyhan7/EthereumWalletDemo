//
//  Send.swift
//  EthereumWalletDemo
//
//  Created by LeonHan on 2022/8/8.
//

import SwiftUI

struct Send: View {
    private  var selectedTokenAbbr: String = ""
    @ObservedObject var viewModel: SendViewModel = SendViewModel()
    
    @State private var showingSelectAccounts = false
    @State private var showingSelectTokens = false
    @State private var showingSelectAccountsForAddress = false
    
    init(selectedTokenAbbr : String) {
        self.selectedTokenAbbr = selectedTokenAbbr
    }

    var body: some View {
        let userModel = viewModel.userModel!
        let tokens = userModel.tokens
        let userModels = viewModel.userModels
        let tokenModel = viewModel.tokenModel

        ZStack {
            ScrollView {
                Spacer().frame(width: .infinity, height: 30)
                HStack {
                    Text("From:").font(.system(size: 14)).frame(minWidth: 60, alignment: .leading)

                    HStack {
                        Image(userModel.iconName)
                            .resizable().aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25)

                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.init(hex: 0x4595f4), lineWidth: 2))
                            .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))

                        VStack {
                            Text(userModel.nickname).font(.system(size: 14)).frame(maxWidth: .infinity, alignment: .leading)
                                .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))

                            Text(userModel.walletAddress).font(.system(size: 7)).frame(maxWidth: .infinity, alignment: .leading)
                                .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))
                        }
                        Spacer()

                        Image("right-arrow")
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
                        showingSelectAccounts = true;
                    })
                    .confirmationDialog("Choose Account", isPresented: $showingSelectAccounts, titleVisibility: .visible) {


                        ForEach( userModels) { (userModel_: UserModel?)  in

                            if (userModel_ != nil){
                                let nickName = userModel_!.nickname;
                                Button(nickName){
                                    viewModel.switchAccount(id: userModel_!.id )
                                }
                            }

                        }
                    }
                HStack {
                    Text("Token:").font(.system(size: 14)).frame(minWidth: 60, alignment: .leading)

                    HStack {
                        Image(tokenModel?.abbr ?? "")
                            .resizable().aspectRatio(contentMode: .fit)
                            .frame(width: 25, height:25)

                            .clipShape(Circle())
                            .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))

                        VStack {
                            Text(tokenModel?.abbr ?? "").font(.system(size: 14)).frame(maxWidth: .infinity, alignment: .leading)
                                .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))
                            Text("\(tokenModel?.count ?? 0)").font(.system(size: 8)).frame(maxWidth: .infinity, alignment: .leading)
                                .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))
                        }
                        Spacer()

                        Image("right-arrow")
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
                        showingSelectTokens = true;
                    })
                    .confirmationDialog("Choose Token", isPresented: $showingSelectTokens, titleVisibility: .visible) {
                        ForEach(tokens) { (tokenModel_: TokenModel?)  in

                            if (tokenModel_ != nil){
                                let abbr = tokenModel_!.abbr;

                                Button(abbr){
                                    viewModel.switchToken(id: tokenModel_!.id)
                                }
                            }
                        }
                    }
                HStack {
                    Text("To:").font(.system(size: 14)).frame(minWidth: 60, alignment: .leading)

                    TextField("public address(0x)", text: $viewModel.receiverAddress){

                    }
                    .textFieldStyle(.roundedBorder)
                    .font(.system(size:10))


                    Spacer()
                }.padding(EdgeInsets(top: 25, leading: 25, bottom: 0, trailing: 0))

                HStack {
                    Spacer().frame(width: 100, alignment: .leading)
                    Button(action: {
                        showingSelectAccountsForAddress = true;
                    }){
                        Text("Transfer between my accounts").font(.system(size: 14))

                    }

                    .confirmationDialog("Choose Account", isPresented: $showingSelectAccountsForAddress, titleVisibility: .visible) {
                        ForEach( userModels) { (userModel_: UserModel?)  in

                            if (userModel_ != nil){
                                let nickName = userModel_!.nickname;
                                Button(nickName){
                                    viewModel.switchUserAddress(id: userModel_!.id )
                                }
                            }
                        }
                    }
                    Spacer()
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
                    VStack {
                        Spacer()

                        Button(action: {
                            viewModel.sendToken();
                        }){
                            Text("Send").font(.system(size: 20))
                        }
                        .buttonStyle(WideButton())
                        .padding(EdgeInsets(top: 0, leading: 40, bottom: 25, trailing: 40))
                    }
                }
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
        .navigationBarTitle("Send to", displayMode: .inline)

        .navigationViewStyle(StackNavigationViewStyle())

        .alert(isPresented: $viewModel.showAlertFromViewModel){

            Alert(title: Text("Notice"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("Close"), action: {
                GlobalData.instance.notifyUserDataUpdate()
            }))
        }
        .contentShape(Rectangle())
        .onTapGesture {
            hideKeyboard()
        }
        .onAppear(){
            viewModel.updateTokenAbbr(selectedTokenAbbr:self.selectedTokenAbbr)
        }
    }
}

struct SendToPage_Previews: PreviewProvider {
    static var previews: some View {
        Send(selectedTokenAbbr: "")
    }
}
