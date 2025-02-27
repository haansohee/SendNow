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
        addChangeSelectedView()
    }
    
    private func setupMainTabBar() {
        tabBar.tintColor = UIColor(named: "TitleColor")
        tabBar.isTranslucent = false
        tabBar.backgroundColor = .systemBackground
        let homeTab = UINavigationController(rootViewController: HomeViewController())
        homeTab.tabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house"), tag: 0)
        let groupTab = UINavigationController(rootViewController: GroupListViewController())
        groupTab.tabBarItem = UITabBarItem(title: "정산모임", image: UIImage(systemName: "rectangle.3.group.bubble"), tag: 1)
        let notificationTab = UINavigationController(rootViewController: NotificationViewController())
        notificationTab.tabBarItem = UITabBarItem(title: "알림", image: UIImage(systemName: "bell"), tag: 2)
        let myPageTab = UINavigationController(rootViewController: MyPageViewController())
        myPageTab.tabBarItem = UITabBarItem(title: "마이페이지", image: UIImage(systemName: "person.text.rectangle"), tag: 3)
        viewControllers = [homeTab, groupTab, notificationTab, myPageTab]
        tabBarController?.setViewControllers(viewControllers, animated: true)
    }
    
    private func addChangeSelectedView() {
        NotificationCenter.default.addObserver(self, selector: #selector(showNotificationView(_:)), name: NSNotification.Name(NotificationName.notificationDidReceive.rawValue), object: nil)
    }
    
    @objc private func showNotificationView(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let index = userInfo["index"] as? Int else { return }
        self.selectedIndex = index
    }
}
