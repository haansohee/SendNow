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
import Alamofire

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        checkServerStatus {[weak self] isServerAvailable in
            if !isServerAvailable { self?.displayServerErrorAndTerminate() }
        }
        guard let nativeAppKey = Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] else { return true }
        RxKakaoSDK.initSDK(appKey: nativeAppKey as! String)
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
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
        Messaging.messaging().isAutoInitEnabled = true
        return true
    }

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}

extension AppDelegate {
    private func checkServerStatus(completion: @escaping(Bool) -> Void) {
        guard let stringURL = Bundle.main.infoDictionary?["Server_URL"] as? String,
              let url = URL(string: "\(stringURL)/SendNow") else {
            completion(false)
            return }
        AF.request(url,
                   method: .get,
                   headers: ["Content-Type": "application/json"]
        ).validate(statusCode: 200..<500).response() { response in
            completion(response.response?.statusCode == 200)        
        }
    }
    
    private func displayServerErrorAndTerminate() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "바로보내", message: "서비스가 일시적으로 이용 불가능합니다. 잠시 후 다시 시도 해 주세요.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
                UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    exit(0)
                }
            })
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first else { return }
            window.rootViewController?.present(alert, animated: true)
        }
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
