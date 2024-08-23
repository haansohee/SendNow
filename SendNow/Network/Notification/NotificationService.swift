//
//  NotificationService.swift
//  SendNow
//
//  Created by 한소희 on 8/2/24.
//

import Foundation

enum NotificationAPIPath: String {
    case sendGroupNotification = "/SendNow/SendGroupNotification"
    case sendFriendNotification = "/SendNow/SendFriendNotification"
}

final class NotificationService {
    private let networkSessionManager = NetworkSessionManager()
    
    func sendGroupNotification(with notificationDomain: GroupNotificationDomain, completion: @escaping(Bool)->Void) {
        let path = NotificationAPIPath.sendGroupNotification.rawValue
        let notificationInfo = notificationDomain.toRequestDTO()
        networkSessionManager.urlPostMethod(path: path, encodeValue: notificationInfo) { result in
            completion(result)
        }
    }
    
    func sendFriendNotification(with notificationDomain: FriendNotificationDomain, completion: @escaping(Bool)->Void) {
        let path = NotificationAPIPath.sendFriendNotification.rawValue
        let notificationInfo = notificationDomain.toRequestDTO()
        networkSessionManager.urlPostMethod(path: path, encodeValue: notificationInfo) { result in
            completion(result)
        }
    }
}
