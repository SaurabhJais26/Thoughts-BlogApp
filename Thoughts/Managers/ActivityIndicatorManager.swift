//
//  ActivityIndicatorManager.swift
//  Thoughts
//
//  Created by Saurabh Jaiswal on 29/07/24.
//

import Foundation

import UIKit

class ActivityIndicatorManager {
    
    static let shared = ActivityIndicatorManager()
    
    private var activityIndicator: UIActivityIndicatorView
    private var effectView: UIVisualEffectView
    private var strLabel: UILabel
    
    private init() {
        self.activityIndicator = UIActivityIndicatorView(style: .white)
        self.effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        self.strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 180, height: 46))
    }

    func showIndicator(_ title: String, vc: UIViewController) {
        guard let navigationController = vc.navigationController else { return }
        
        navigationController.view.isUserInteractionEnabled = false
        vc.view.isUserInteractionEnabled = false
        navigationController.navigationBar.isUserInteractionEnabled = false
        
        strLabel.removeFromSuperview()
        activityIndicator.removeFromSuperview()
        effectView.removeFromSuperview()
        
        strLabel.text = title
        strLabel.font = .systemFont(ofSize: 15, weight: .medium)
        strLabel.textColor = UIColor.white
        
        effectView.frame = CGRect(
            x: vc.view.frame.midX - strLabel.frame.width/2,
            y: vc.view.frame.midY - strLabel.frame.height/2,
            width: 180,
            height: 46
        )
        effectView.layer.cornerRadius = 15
        effectView.layer.masksToBounds = true
        
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 46, height: 46)
        activityIndicator.startAnimating()
        
        effectView.contentView.addSubview(activityIndicator)
        effectView.contentView.addSubview(strLabel)
        
        vc.view.addSubview(effectView)
    }

    func hideIndicator(from vc: UIViewController) {
        guard let navigationController = vc.navigationController else { return }
        
        if activityIndicator.isAnimating {
            activityIndicator.stopAnimating()
            effectView.removeFromSuperview()
            
            navigationController.view.isUserInteractionEnabled = true
            vc.view.isUserInteractionEnabled = true
            navigationController.navigationBar.isUserInteractionEnabled = true
        }
    }
}
