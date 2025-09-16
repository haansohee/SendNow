//
//  NotificationListResponseDTO.swift
//  SendNow
//
//  Created by 한소희 on 9/2/24.
//

import Foundation

struct NotificationListResponseDTO: Codable {
    let notificationID: Int
    let senderUserID: Int
    let receiverUserID: Int
    let notificationBody: String
    let isRead: Bool
    let subject: Int
}
