//
//  SceneDelegate.swift
//  SendNow
//
//  Created by 한소희 on 3/25/24.
//

import UIKit
import RxKakaoSDKAuth
import KakaoSDKAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.backgroundColor = .systemBackground
        window?.makeKeyAndVisible()
//        guard UserDefaults.standard.string(forKey: MemberInfoField.email.rawValue) != nil else {
//            window?.rootViewController = UINavigationController(rootViewController: SigninViewController())
//            return
//        }
//        window?.rootViewController = UINavigationController(rootViewController: MainTabBarController())
        window?.rootViewController = UINavigationController(rootViewController: SigninViewController())
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.rx.handleOpenUrl(url: url)
            }
        }
    }
}

extension SceneDelegate {
    func changeRootViewController(_ viewController: UIViewController, animated: Bool) {
        guard let window = self.window else { return }
        window.rootViewController = viewController
        UIView.transition(with: window, duration: 0.2, options: [.transitionCrossDissolve],animations: nil, completion: nil)
    }
}
