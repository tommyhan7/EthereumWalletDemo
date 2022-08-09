//
//  TokenViewModel.swift
//  EthereumWalletDemo
//
//  Created by LeonHan on 2022/8/8.
//

import SwiftUI

/// viewModel for token page
class TokenViewModel: ObservableObject {
//    /// all user models
//    private(set) var userModels = GlobalData.instance.userArrayModel!.data
//    /// current token
//    @Published private(set) var tokenModel: TokenModel?
//    /// current user
//    @Published private(set) var userModel: UserModel?
//    
//    init() {
//        var userIndex = GlobalData.instance.userIndex
//        if userIndex >= userModels.count {
//            userIndex = 0
//        }
//        userModel = userModels[GlobalData.instance.userIndex]
//        
//        NotificationCenter.default.addObserver(forName: .UpdateUserData, object: nil, queue: nil) { [weak self] notif in
//            guard let self = self else { return }
//            self.objectWillChange.send()
//        }
//
//    }
//    
//    /// update view model info by token abbr
//    /// different tokens use the same page view, we call this function to show the data of the token user choosen
//    /// - Parameter selectedTokenAbbr: token abbr
//    func updateTokenAbbr(selectedTokenAbbr: String) {
//        userModel?.findTokenByAbbr(abbr: selectedTokenAbbr, handler: { index, tokenModel_ in
//            if let tokenModel_ = tokenModel_ {
//                tokenModel = tokenModel_
//            }
//        })
//    }
}
