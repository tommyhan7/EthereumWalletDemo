//
//  BuyViewModel.swift
//  EthereumWalletDemo
//
//  Created by LeonHan on 2022/8/8.
//

import Foundation
import SwiftUI

/// view model
class BuyViewModel: ObservableObject {
    /// all user data
    private(set) var userModels = GlobalData.instance.userArrayModel!.data
    /// current user
    @Published private(set) var userModel: UserModel?
    //current token
    @Published private(set) var tokenModel: TokenModel?
    /// for alertview
    @Published var showAlertFromViewModel = false
    /// for alertview
    @Published var alertMessage: String = ""
    @Published var tokenNumberString: String = "0"
    
    /// same as SendToViewModel
    func updateTokenAbbr(selectedTokenAbbr: String) {
        self.userModel?.findTokenByAbbr(abbr: selectedTokenAbbr) { index, tokenModel_ in
            if let tokenModel_ = tokenModel_ {
                self.tokenModel = tokenModel_
            } else {
                self.updateToken()
            }
        }
    }
    
    /// same as SendToViewModel
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
    
    /// same as SendToViewModel
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
    
    /// same as SendToViewModel
    func showAlert(message:String) {
        showAlertFromViewModel = true
        alertMessage = message
    }

    /// same as SendToViewModel
    func switchToken(id: UUID) {
        //TODO: use dictionary or index to improve performance
        userModel?.findTokenById(id: id, handler: { index, tokenModel_ in
            if let tokenModel_ = tokenModel_ {
                tokenModel = tokenModel_
                tokenNumberString = "0"
            }
        })
    }

    /// add token to current account
    /// no fee is charged
    func buyToken() {
        let tokenNumber = Double(tokenNumberString) ?? 0.0
        if tokenNumber <= 0 {
            showAlert(message: "Please input a valid token number")
            return
        }
        
        if tokenNumber > 1000 {
            showAlert(message: "Token number should not exceed 1000")
            return
        }
        tokenModel?.addCount(count: tokenNumber)
        GlobalData.instance.saveUserData()
        showAlert(message: "You have bought \(tokenNumber) \(tokenModel?.abbr ?? "Token") for \(userModel?.nickname ?? "")")
    }
}
