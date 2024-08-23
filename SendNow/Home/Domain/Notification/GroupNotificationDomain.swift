//
//  NotificationDomain.swift
//  SendNow
//
//  Created by 한소희 on 8/5/24.
//

import Foundation

struct GroupNotificationDomain {
    let senderUserID: Int
    let receiverUserID: [Int]
    let groupName: String
}

extension GroupNotificationDomain {
    func toRequestDTO() -> GroupNotificationRequestDTO {
        return .init(senderUserID: senderUserID, receiverUserID: receiverUserID, groupName: groupName)
    }
}
