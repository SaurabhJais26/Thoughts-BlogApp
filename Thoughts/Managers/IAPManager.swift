//
//  IAPManager.swift
//  Thoughts
//
//  Created by Saurabh Jaiswal on 17/07/24.
// code.Saurabh.Thoughts.premium

import Foundation
import Purchases
import StoreKit

final class IAPManager {
    
    static let shared = IAPManager()
    
    static let formatter = ISO8601DateFormatter()
    
    private var postEligibleViewDate: Date? {
        get {
            guard let string = UserDefaults.standard.string(forKey: "postEligibleViewDate") else {
                return nil
            }
            return IAPManager.formatter.date(from: string)
        }
        set {
            guard let date = newValue else {
                return
            }
            let string = IAPManager.formatter.string(from: date)
            UserDefaults.standard.set(string, forKey: "postEligibleViewDate")
        }
    }
    
    private init() {}
    
    func isPremium() -> Bool {
        return UserDefaults.standard.bool(forKey: "premium")
    }
    
    public func getSubscriptionStatus(completion: ((Bool) -> Void)?) {
        Purchases.shared.purchaserInfo { info, error in
            guard let entitlements = info?.entitlements,
                  error == nil else {
                return
            }
            
            print("Entitlements --->", entitlements)
            if entitlements.all["Premium"]?.isActive == true {
                print("Got updated status of subscribed")
                UserDefaults.standard.set(true, forKey: "premium")
                completion?(true)
            } else {
                print("Got updated status of NOT subscribed")
                UserDefaults.standard.set(false, forKey: "premium")
                completion?(false)
            }
        }
    }
    
    public func fetchPackages(completion: @escaping (Purchases.Package?) -> Void) {
        Purchases.shared.offerings { offerings, error in
            guard let package = offerings?.offering(identifier: "default")?.availablePackages.first,
                  error == nil else {
                completion(nil)
                return
            }
            completion(package)
        }
    }
    
    public func subscribe(package: Purchases.Package, completion: @escaping (Bool) -> Void) {
        guard !isPremium() else {
            completion(true)
            print("User already subscribed.")
            return
        }
        
        Purchases.shared.purchasePackage(package) { transaction, info, error, userCancelled in
            guard let transaction = transaction,
                  let entitlements = info?.entitlements,
                  error == nil,
                  !userCancelled else {
                return
            }
            
            switch transaction.transactionState {
            case .purchasing:
                print("Purchasing")
            case .purchased:
                if entitlements.all["Premium"]?.isActive == true {
                    print("Purchased!")
                    UserDefaults.standard.set(true, forKey: "premium")
                    completion(true)
                } else {
                    print("Purchased failed")
                    UserDefaults.standard.set(false, forKey: "premium")
                    completion(false)
                }
            case .failed:
                print("Failed")
            case .restored:
                print("Restored")
            case .deferred:
                print("Deferred")
            @unknown default:
                print("Default case")
            }
        }
    }
    
    public func restorePurchases(completion: @escaping (Bool) -> Void) {
        Purchases.shared.restoreTransactions { info, error in
            guard let entitlements = info?.entitlements,
                  error == nil else {
                return
            }
            if entitlements.all["Premium"]?.isActive == true {
                print("Restored Success.")
                UserDefaults.standard.set(true, forKey: "premium")
                completion(true)
            } else {
                print("Restored Failed.")
                UserDefaults.standard.set(false, forKey: "premium")
                completion(false)
            }
        }
    }
}

// MARK: - Track Post Views

extension IAPManager {
    var canViewPost: Bool {
        if isPremium() {
            return true
        }
        guard let date = postEligibleViewDate else {
            return true
        }
        UserDefaults.standard.set(0, forKey: "post_views")
        return Date() >= date
    }
    
    public func logPostViewed() {
        let total = UserDefaults.standard.integer(forKey: "post_views")
            UserDefaults.standard.set(total+1, forKey: "post_views")
        
        if total == 2 {
            let hour: TimeInterval = 60 * 60
            postEligibleViewDate = Date().addingTimeInterval(hour * 24)
        }
    }
}
