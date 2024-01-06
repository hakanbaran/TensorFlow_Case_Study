//
//  TabBarVC.swift
//  TensorFlow_Case_Study
//
//  Created by Hakan Baran on 6.01.2024.
//

import UIKit

class TabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .dark
        
        let homeVC = HomeVC()
        
        tabBar.backgroundColor = .blue
        tabBar.tintColor = .red
        
        homeVC.navigationItem.largeTitleDisplayMode = .always
        
        let navHome = UINavigationController(rootViewController: homeVC)
        
        navHome.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "person"), tag: 1)
        
        navHome.navigationBar.prefersLargeTitles = true
        
        setViewControllers([navHome], animated: true)
    }
}
