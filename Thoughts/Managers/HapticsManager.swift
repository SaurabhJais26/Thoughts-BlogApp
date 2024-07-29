//
//  HapticsManager.swift
//  Thoughts
//
//  Created by Saurabh Jaiswal on 29/07/24.
//

import Foundation
import UIKit

class HapticsManager {
    static let shared = HapticsManager()
    
    private init() {}
    
    func vibrateForSelection() {
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }
    
    func vibrate(for type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }
}
