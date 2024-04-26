//
//  MainTabBarController.swift
//  SendNow
//
//  Created by 한소희 on 4/9/24.
//

import Foundation
import UIKit

final class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMainTabBar()
    }
    
    private func setupMainTabBar() {
        tabBar.tintColor = UIColor(named: "TitleColor")
        tabBar.isTranslucent = false
        tabBar.backgroundColor = .systemBackground
        let homeTab = UINavigationController(rootViewController: HomeViewController())
        homeTab.tabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house"), tag: 0)
        viewControllers = [homeTab]
        tabBarController?.setViewControllers(viewControllers, animated: true)
    }
}
