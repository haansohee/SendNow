//
//  AppDelegate.swift
//  SendNow
//
//  Created by 한소희 on 3/25/24.
//

import UIKit
import FirebaseCore
import FirebaseMessaging
import KakaoSDKAuth
import RxKakaoSDKAuth
import RxKakaoSDKCommon
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        guard let nativeAppKey = Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] else { return true }
        RxKakaoSDK.initSDK(appKey: nativeAppKey as! String)
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.resignOnTouchOutside = true
        FirebaseApp.configure()
        
        UNUserNotificationCenter.current().delegate = self
        let authOptions:  UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { isSetNoti, error in
            if let error = error {
                print("Notification Authorization Request ERROR : \(error.localizedDescription)")
                return
            }
            UserDefaults.standard.set(isSetNoti, forKey: MemberInfoField.isSetNoti.rawValue)
        }
        application.registerForRemoteNotifications()
        
        Messaging.messaging().delegate = self
        return true
    }

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let currentBadgeCount = UserDefaults.standard.integer(forKey: MemberInfoField.notificationBadge.rawValue)
        UserDefaults.standard.set(currentBadgeCount + 1, forKey: MemberInfoField.notificationBadge.rawValue)
        UNUserNotificationCenter.current().setBadgeCount(currentBadgeCount + 1) { error in
            if let error = error {
                print("Set Badge Count ERROR: \(error.localizedDescription)")
                return
            }
        }
        completionHandler([.list, .banner, .badge, .banner])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        NotificationCenter.default.post(name: NSNotification.Name(NotificationName.notificationDidReceive.rawValue), object: nil, userInfo: ["index": 2])
        completionHandler()
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken = fcmToken else { return }
        UserDefaults.standard.set(fcmToken, forKey: MemberInfoField.fcmToken.rawValue)
    }
}
