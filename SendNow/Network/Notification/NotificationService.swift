//
//  NotificationService.swift
//  SendNow
//
//  Created by 한소희 on 8/2/24.
//

import Foundation

enum NotificationAPIPath: String {
    case sendGroupNotification = "/SendNow/sendGroupNotification"
    case sendFriendNotification = "/SendNow/sendFriendNotification"
    case getNotificationList = "/SendNow/getNotificationList"
    case updateNoficiationIsRead = "/SendNow/updateNotificationIsRead"
    case updateNotificationAll = "/SendNow/updateNotificationAll"
}

final class NotificationService {
    private let networkSessionManager = NetworkSessionManager()
    
    func sendGroupNotification(with notificationDomain: GroupNotificationDomain, completion: @escaping(Bool)->Void) {
        let path = NotificationAPIPath.sendGroupNotification.rawValue
        let notificationInfo = notificationDomain.toRequestDTO()
        networkSessionManager.urlPostMethod(path: path, encodeValue: notificationInfo, completion: completion)
    }
    
    func sendFriendNotification(with notificationDomain: FriendNotificationDomain, completion: @escaping(Bool)->Void) {
        let path = NotificationAPIPath.sendFriendNotification.rawValue
        let notificationInfo = notificationDomain.toRequestDTO()
        networkSessionManager.urlPostMethod(path: path, encodeValue: notificationInfo, completion: completion)
    }
    
    func getNotificationList(with userID: Int, completion: @escaping([NotificationListDomain])->Void) {
        let path = "\(NotificationAPIPath.getNotificationList.rawValue)?userID=\(userID)"
        networkSessionManager.urlGetMethod(path: path, requestDTO: [NotificationListResponseDTO].self) { notificationListInfo in
            switch notificationListInfo {
            case .success(let responseDTO):
                let notificationList = responseDTO.map { $0.toDomain() }
                completion(notificationList)
            case .failure(let error):
                print("get Notification List Error: \(error)")
            }
        }
    }
    
    func updateNotificationIsRead(with notificationID: Int, userID: Int, completion: @escaping(Bool)->Void) {
        let path = NotificationAPIPath.updateNoficiationIsRead.rawValue
        let notificationRequestDTO = UpdateNotificationRequestDTO(notificationID: notificationID, userID: userID)
        networkSessionManager.urlPostMethod(path: path, encodeValue: notificationRequestDTO, completion: completion)
    }
}
