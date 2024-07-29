//
//  TabBarViewController.swift
//  Thoughts
//
//  Created by Saurabh Jaiswal on 17/07/24.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("TabBarViewController loaded")
        setUpControllers()
    }
    
    private func setUpControllers() {
        guard let currentUserEmail = UserDefaults.standard.string(forKey: "email") else {
            print("No email found in UserDefaults")
            showMissingEmailAlert()
            return
        }
        print("Current user email: \(currentUserEmail)")
        let home = HomeViewController()
        home.title = "Home"
        print("HomeViewController initialized")
        let profile = ProfileViewController(currentEmail: currentUserEmail)
        profile.title = "Profile"
        print("ProfileViewController initialized with email: \(currentUserEmail)")
        home.navigationItem.largeTitleDisplayMode = .always
        profile.navigationItem.largeTitleDisplayMode = .always
        
        let nav1 = UINavigationController(rootViewController: home)
        let nav2 = UINavigationController(rootViewController: profile)
        
        nav1.navigationBar.prefersLargeTitles = true
        nav2.navigationBar.prefersLargeTitles = true
        
        nav1.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle"), tag: 2)
        setViewControllers([nav1, nav2], animated: true)
        
        print("Tab bar controllers set up")
    }
    
    private func showMissingEmailAlert() {
            let alert = UIAlertController(title: "Error", message: "No email found. Please sign in again.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                // You can navigate to the sign-in screen here
                let signInVC = SignInViewController()
                let navVC = UINavigationController(rootViewController: signInVC)
                self.view.window?.rootViewController = navVC
            }))
            present(alert, animated: true, completion: nil)
        }

}
