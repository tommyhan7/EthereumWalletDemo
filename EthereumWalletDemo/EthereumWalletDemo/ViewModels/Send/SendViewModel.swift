//
//  SendViewModel.swift
//  EthereumWalletDemo
//
//  Created by LeonHan on 2022/8/8.
//

import Foundation
import SwiftUI

/// send token to others
class SendViewModel: ObservableObject {
    private(set) var userModels = GlobalData.instance.userArrayModel!.data
    
    @Published private(set) var userModel: UserModel?
    @Published private(set) var tokenModel: TokenModel?
    @Published var receiverAddress: String = ""
    
    @Published var showAlertFromViewModel = false
    @Published var alertMessage: String = ""
    @Published var tokenNumberString: String = "0"

    /// update view model info by token abbr
    /// different tokens use the same page view, we call this function to show the data of the token user choosen
    /// - Parameter selectedTokenAbbr: token abbr
    func updateTokenAbbr(selectedTokenAbbr: String) {
        self.userModel?.findTokenByAbbr(abbr: selectedTokenAbbr) { index, tokenModel_ in
            if let tokenModel_ = tokenModel_ {
                self.tokenModel = tokenModel_
            } else {
                self.updateToken()
            }
        }
    }
    
    /// set default token for current user
    private func updateToken() {
        if let userModel = userModel, userModel.tokens.count > 0 {
            tokenModel = userModel.tokens[0]
        }
    }
    
    required init() {
        var userIndex = GlobalData.instance.userIndex
        if userIndex >= userModels.count {
            userIndex = 0
        }
        userModel = userModels[GlobalData.instance.userIndex]
        updateToken()
    }
    
    /// fetch user info after account changed
    /// - Parameter id: user uuid
    func switchAccount(id: UUID) {
        GlobalData.instance.userArrayModel?.findUserById(id: id) { index, userModel_ in
            if userModel_ == nil {
                return
            }
            GlobalData.instance.userIndex = index
            userModel = userModels[GlobalData.instance.userIndex]
            updateToken()
            tokenNumberString = "0"
        }
    }
    
    /// show alertview
    /// - Parameter message: alertview message
    func showAlert(message:String) {
        showAlertFromViewModel = true
        alertMessage = message
    }
    
    /// fetch user wallet address
    /// - Parameter id: user uuid
    func switchUserAddress(id: UUID) {
        //TODO: use dictionary or index to improve performance
        if (id == userModel?.id) {
            showAlert(message: "You should not choose same accounts")
            return
        }
        GlobalData.instance.userArrayModel?.findUserById(id: id) { index, userModel_ in
            if let userModel = userModel_  {
                receiverAddress = userModel.walletAddress
            }
        }
    }
    
    /// fetch token info after token changed
    /// - Parameter id: token uuid
    func switchToken(id: UUID) {
        //TODO: use dictionary or index to improve performance
        userModel?.findTokenById(id: id, handler: { index, tokenModel_ in
            if let tokenModel_ = tokenModel_ {
                tokenModel = tokenModel_
                tokenNumberString = "0"
            }
        })
    }

    /// send token to others
    /// 1. token count of sender user will be decreased
    /// 2. if receiver wallet address belongs to one of the local accounts, the token will be added to that account
    /// 3. no fee is charged
    func sendToken() {
        //receiverAddress must begin with "0x"
        if receiverAddress.lengthOfBytes(using: .utf8) < 3 || !receiverAddress.starts(with: "0x") {
            showAlert(message: "Address must starts with 0x")
            return
        }
        
        //can not send to same account
        if receiverAddress == userModel?.walletAddress {
            showAlert(message: "You should not choose same accounts")
            return
        }

        let tokenNumber = Double(tokenNumberString) ?? 0.0
        
        if tokenNumber <= 0 {
            showAlert(message: "Please input a valid token number")
            return
        }
        
        let tokenCount = tokenModel?.count ?? 0.0
        if tokenNumber > tokenCount {
            showAlert(message: "Not enough \(tokenModel?.abbr ?? "Token") to send.")
            return
        }
        //decrease the token number from sender
        tokenModel?.addCount(count: -tokenNumber)
        //if receiver wallet address belongs to one of the local accounts, the token will be added to that account
        GlobalData.instance.userArrayModel?.findUserByWalletAddress(address: receiverAddress, handler: { index, userModel_ in
            if let receiverUserModel = userModel_, let tokenModel = tokenModel {
                let tokenAbbr = tokenModel.abbr
                receiverUserModel.findTokenByAbbr(abbr: tokenAbbr) { index, tokenModel_ in
                    if let tokenModel_ = tokenModel_ {
                        tokenModel_.addCount(count: tokenNumber)
                    } else {
                        _ = receiverUserModel.addToken(abbr: tokenAbbr, count: tokenNumber)
                    }
                }
            }
        })
        //save to userdefaults
        GlobalData.instance.saveUserData()
        showAlert(message: "\(tokenNumber) \(tokenModel?.abbr ?? "Token") has been sent from \(userModel?.nickname ?? "") to \(receiverAddress)")
    }
}
