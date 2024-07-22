//
//  IAPManager.swift
//  Thoughts
//
//  Created by Saurabh Jaiswal on 17/07/24.
// code.Saurabh.Thoughts.premium

import Foundation
import Purchases

final class IAPManager {
    static let shared = IAPManager()
    
    private init() {}
    
    func isPremium() -> Bool {
        return false
    }
    
    func subscribe() {}
    
    func restorePurchases() {}
}
