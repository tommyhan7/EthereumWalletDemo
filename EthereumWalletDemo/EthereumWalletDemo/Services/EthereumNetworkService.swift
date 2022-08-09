//
//  EthereumNetworkService.swift
//  EthereumWalletDemo
//
//  Created by LeonHan on 2022/8/9.
//

import UIKit
import EthereumKit
import HdWalletKit
import HsToolKit
import CoreData

class EthereumNetworkService {
    var ethereumService: Kit

    static var priceDict: [String: Double] = [:]
    static let pricesKey = "prices"

    private let defaultWords = ["apart", "approve", "black", "comfort", "steel", "spin", "real", "renew", "tone", "primary", "key"]
    private let defaultRpcApi: RpcApi = .infura(id: "2a1306f1d12f4c109a4d4fb9be46b02e", secret: "fc479a9290b64a84a15fa6544a130218")
    private let defaultEtherscanApiKey = "GKNHXT22ED7PRVCKZATFZQD1YI7FK9AAYE"
    private let defaultWalletId = "Wallet"

    init() {
        ethereumService = try! Kit.instance(
            words: defaultWords,
            syncMode: .api,
            networkType: .mainNet,
            rpcApi: defaultRpcApi,
            etherscanApiKey: defaultEtherscanApiKey,
            walletId: defaultWalletId,
            minLogLevel: .error
        )

        EthereumNetworkService.initializePrices()
    }

    func startService() {
        ethereumService.start()
    }

    func stopService() {
        ethereumService.stop()
    }

    func getPriceData(completion: @escaping (() -> Void)) {
        let queue = DispatchQueue.init(label: "getPriceData")
        let group = DispatchGroup()

        for tokenAbbr in EthereumNetworkService.priceDict.keys {
            queue.async(group: group, execute: {
                group.enter()

                let url = "https://api.binance.com/api/v3/ticker/price?symbol=\(tokenAbbr)USDT"

                let urlRequest = URLRequest(url: URL(string: url)!)
                let config = URLSessionConfiguration.default
                config.timeoutIntervalForRequest = 15
                config.requestCachePolicy = .reloadIgnoringLocalCacheData
                let session = URLSession(configuration: config)

                session.dataTask(with: urlRequest) { (data,_,_) in
                    if let resultData = data {
                        do {
                            let jsonObject = try JSONSerialization.jsonObject(with: resultData, options:[.mutableContainers,.mutableLeaves])
                            if let priceString = EthereumNetworkService.priceDict[tokenAbbr] {
                                let price = Double(priceString)
                                if (price > 0) {
                                    EthereumNetworkService.priceDict[tokenAbbr] = price
                                }
                            }
                            print(jsonObject)
                        } catch {
                            print("error")
                        }
                        group.leave()
                    }
                }.resume()
            })
        }

        group.notify(queue: queue) {
            print("finished")
            DispatchQueue.main.async {
                UserDefaults.standard.setValue(EthereumNetworkService.priceDict, forKey: EthereumNetworkService.pricesKey)
                UserDefaults.standard.synchronize()
            }
        }
        return
    }

    static func initializePrices() {
        if priceDict.isEmpty {
            let asset = NSDataAsset(name: "MockPrices", bundle: Bundle.main)
            priceDict = (try? JSONSerialization.jsonObject(with: asset!.data) as? [String: Double]) ?? [:]

            UserDefaults.standard.setValue(priceDict, forKey: pricesKey)
            UserDefaults.standard.synchronize()
        }
    }
}
