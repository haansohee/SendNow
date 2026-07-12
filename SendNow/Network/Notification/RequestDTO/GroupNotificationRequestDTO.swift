//
//  NotificationRequestDTO.swift
//  SendNow
//
//  Created by 한소희 on 8/5/24.
//

import Foundation

struct GroupNotificationRequestDTO: Codable {
    let senderUserID: Int
    let receiverUserID: [Int]
    let groupName: String
}
