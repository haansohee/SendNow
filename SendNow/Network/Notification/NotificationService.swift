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
    case sendRemittanceNotification = "/SendNow/sendRemittanceNotification"
    case getNotificationList = "/SendNow/getNotificationList"
    case updateNoficiationIsRead = "/SendNow/updateNotificationIsRead"
    case updateNotificationAll = "/SendNow/updateNotificationAll"
    case updateNotificationState = "/SendNow/updateNotificationState/"
    case deleteNotification = "/SendNow/deleteNotification"
}

final class NotificationService {
    private let networkSessionManager = NetworkSessionManager()
    
    func sendGroupNotification(with requestDTO: GroupNotificationRequestDTO, completion: @escaping(Bool, Int)->Void) {
        let path = NotificationAPIPath.sendGroupNotification.rawValue
        networkSessionManager.urlPostMethod(path: path, encodeValue: requestDTO, completion: completion)
    }
    
    func sendFriendNotification(with requestDTO: FriendNotificationRequestDTO, completion: @escaping(Bool, Int)->Void) {
        let path = NotificationAPIPath.sendFriendNotification.rawValue
        networkSessionManager.urlPostMethod(path: path, encodeValue: requestDTO, completion: completion)
    }
    
    func sendRemittanceNotification(with settlementID: Int, completion: @escaping(Bool, Int)->Void) {
        let path = "\(NotificationAPIPath.sendRemittanceNotification.rawValue)?settlementID=\(settlementID)"
        networkSessionManager.urlPostMethod(path: path, encodeValue: settlementID, completion: completion)
    }
    
    func getNotificationList(with userID: Int, completion: @escaping(Result<[NotificationList], Error>)->Void) {
        let path = "\(NotificationAPIPath.getNotificationList.rawValue)?userID=\(userID)"
        networkSessionManager.urlGetMethod(path: path, requestDTO: [NotificationListResponseDTO].self) { notificationListInfo in
            switch notificationListInfo {
            case .success(let responseDTO):
                let notificationListDomain = responseDTO.map { $0.toDomain() }
                completion(.success(notificationListDomain))
            case .failure(let error):
                print("get Notification List Error: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    func updateNotificationIsRead(with notificationID: Int, userID: Int, completion: @escaping(Bool, Int)->Void) {
        let path = NotificationAPIPath.updateNoficiationIsRead.rawValue
        let notificationRequestDTO = UpdateNotificationRequestDTO(notificationID: notificationID, userID: userID)
        networkSessionManager.urlPostMethod(path: path, encodeValue: notificationRequestDTO, completion: completion)
    }
    
    func updateNotificationState(with requestDTO: UpdateNotificationStateRequestDTO, completion: @escaping(Bool, Int)->Void) {
        let path = NotificationAPIPath.updateNotificationState.rawValue
        networkSessionManager.urlPostMethod(path: path, encodeValue: requestDTO, completion: completion)
    }
    
    func deleteNotification(with userID: Int, completion: @escaping(Bool)->Void) {
        let path = "\(NotificationAPIPath.deleteNotification.rawValue)?userID=\(userID)"
        networkSessionManager.urlDeleteMethod(path: path, encodeValue: userID, completion: completion)
    }
}
