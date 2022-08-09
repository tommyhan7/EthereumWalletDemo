//
//  Toast.swift
//  EthereumWalletDemo
//
//  Created by LeonHan on 2022/8/9.
//

import SwiftUI

struct Toast: View {
    @Binding var isShow: Bool
    let info: String
    @State private var isShowAnimation: Bool = true
    @State private var duration : Double
    
    init(isShow: Binding<Bool>, info: String = "", duration: Double = 1.0) {
        self._isShow = isShow
        self.info = info
        self.duration = duration
    }
    
    var body: some View {
        ZStack {
            Text(info)
                .font(.system(size: 14))
                .foregroundColor(.white)
                .frame(minWidth: 80, alignment: Alignment.center)
                .zIndex(1.0)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(Color(hex:0xBBBBBB))
                        .opacity(0.8)
                )
        }
        .onAppear() {
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                isShowAnimation = false
            }
        }
        .padding()
        .opacity(isShowAnimation ? 1 : 0)
        .animation(.easeIn(duration: 0.8))
        .edgesIgnoringSafeArea(.all)
        .onChange(of: isShowAnimation) { e in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                self.isShow = false
            }
        }
    }
}

extension View {
    func toast(isShow: Binding<Bool>, info: String = "", duration: Double = 1.0) -> some View {
        ZStack {
            self
            if isShow.wrappedValue {
                Toast(isShow:isShow, info: info, duration: duration)
            }
        }
    }
}
