//
//  AppDelegate.swift
//  SendNow
//
//  Created by 한소희 on 3/25/24.
//

import UIKit
import KakaoSDKAuth
import RxKakaoSDKAuth
import RxKakaoSDKCommon

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        guard let nativeAppKey = Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] else { return true }
        RxKakaoSDK.initSDK(appKey: nativeAppKey as! String)
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}

