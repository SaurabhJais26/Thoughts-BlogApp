//
//  ViewController.swift
//  Thoughts
//
//  Created by Saurabh Jaiswal on 17/07/24.
//

import UIKit

class HomeViewController: UIViewController {
    
    private let composeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.setImage(UIImage(systemName: "square.and.pencil", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .medium)), for: .normal)
        button.layer.cornerRadius = 35
        button.layer.shadowColor = UIColor.label.cgColor
        button.layer.shadowOpacity = 0.4
        button.layer.shadowRadius = 10
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(composeButton)
        composeButton.addTarget(self, action: #selector(didTapCreate), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        composeButton.frame = CGRect(
            x: view.frame.width - 88,
            y: view.frame.height - 88 - view.safeAreaInsets.bottom,
            width: 70,
            height: 70
        )
    }
    
    @objc private func didTapCreate() {
        let vc = CreateNewPostViewController()
        vc.title = "Create Post"
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
    }
}

