//
//  Persistence.swift
//  EthereumWalletDemo
//
//  Created by LeonHan on 2022/8/8.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "EthereumWalletDemo")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    var currentAccount: Account? {
        let accounts = allAccounts
        if accounts.isEmpty {
            return nil
        } else {
            for account in accounts {
                if account.isCurrent {
                    return account
                }
            }
            return accounts.first
        }
    }

    var allAccounts: [Account] {
        let request = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Account")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Account.name, ascending: true)]
        return (try? container.viewContext.fetch(request) as? [Account]) ?? []
    }

    func value(of tokenName: String) -> Double {
        guard let tokens = currentAccount?.tokens else {
            return 0
        }
        for token in tokens {
            if let currentToken = token as? Token, let currentPrice = EthereumNetworkService.priceDict[currentToken.name ?? ""], tokenName == currentToken.name {
                return currentToken.quantity * currentPrice
            }
        }
        return 0
    }

    func totalValue() -> Double {
        guard let tokens = currentAccount?.tokens else {
            return 0
        }
        var totalSum: Double = 0
        for token in tokens {
            if let currentToken = token as? Token, let currentPrice = EthereumNetworkService.priceDict[currentToken.name ?? ""] {
                totalSum += currentToken.quantity * currentPrice
            }
        }
        return totalSum
    }

    func change(to account: Account) {
        currentAccount?.isCurrent = false
        account.isCurrent = true

        do {
            try container.viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    func send(tokenName: String, amount: Double) -> Bool {
        guard let tokens = currentAccount?.tokens else {
            return false
        }
        for currentToken in tokens {
            if let currentTokenObj = currentToken as? Token, currentTokenObj.name == tokenName {
                if currentTokenObj.quantity > amount {
                    currentTokenObj.quantity -= amount
                } else {
                    return false
                }
            }
        }

        do {
            try container.viewContext.save()
            return true
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    func receive(tokenName: String, amount: Double) {
        guard let tokens = currentAccount?.tokens else {
            return
        }
        for currentToken in tokens {
            if let currentTokenObj = currentToken as? Token, currentTokenObj.name == tokenName {
                currentTokenObj.quantity += amount
            }
        }

        do {
            try container.viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
