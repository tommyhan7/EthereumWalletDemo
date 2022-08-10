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

        EthereumNetworkService.initializeAccounts()
        EthereumNetworkService.initializePrices()
    }

    func startService() {
        ethereumService.start()
    }

    func stopService() {
        ethereumService.stop()
    }

    func getPriceData(completion: @escaping () -> Void) {
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
                            let jsonObject = try JSONSerialization.jsonObject(with: resultData, options:[.mutableContainers,.mutableLeaves]) as? [String: String]
                            let symbol = jsonObject?["symbol"] as? NSString
                            if let abbr = symbol?.substring(to: 3), let price = jsonObject?["price"], let _ = EthereumNetworkService.priceDict[abbr] {
                                let price = Double(price)
                                if (price ?? 0 > 0) {
                                    EthereumNetworkService.priceDict[abbr] = price
                                }
                            }
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
                completion()
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

    /*{
        "walletAddress": "0xa08a0d955288677188200118e6f8e27543cd761a",
        "iconName": "Account1",
        "nickname": "Account 1",
        "tokens": [
            {
                "abbr": "BTC",
                "count": 28.1745675897654
            },
            {
                "abbr": "ETH",
                "count": 70.5098453523584
            },
            {
                "abbr": "XRP",
                "count": 45.39087976453554
            },
            {
                "abbr": "BNB",
                "count": 67.01414950513691
            },
            {
                "abbr": "EOS",
                "count": 23.75649434123553
            }
        ]
    }*/
    static func initializeAccounts() {
        let context = PersistenceController.shared.container.viewContext
        let result = try? context.fetch(NSFetchRequest<NSFetchRequestResult>.init(entityName: "Account")) as? [Account]
        guard let accounts = result, !accounts.isEmpty else {
            let asset = NSDataAsset(name: "AccountPreloadData", bundle: Bundle.main)
            if let accountsData = try? JSONSerialization.jsonObject(with: asset!.data) as? [String: Any], let accounts = accountsData["data"] as? [[String: Any]] {
                for account in accounts {
                    let accountEntity = Account(context: context)
                    // "walletAddress"
                    if let walletAddress = account["walletAddress"] as? String {
                        accountEntity.address = walletAddress
                    }
                    // "iconName"
                    if let iconName = account["iconName"] as? String {
                        accountEntity.avatar = iconName
                    }
                    // "nickname"
                    if let nickname = account["nickname"] as? String {
                        accountEntity.name = nickname
                    }
                    // "tokens"
                    if let tokens = account["tokens"] as? [[String: Any]] {
                        let tokenEntities: NSMutableSet = []
                        for token in tokens {
                            let tokenEntity = Token(context: context)
                            if let abbr = token["abbr"] as? String {
                                tokenEntity.name = abbr
                            }
                            if let count = token["count"] as? Double {
                                tokenEntity.quantity = count
                            }
                            tokenEntities.add(tokenEntity)
                        }
                        accountEntity.tokens = tokenEntities
                    }
                }
            }
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            return
        }
    }
}
