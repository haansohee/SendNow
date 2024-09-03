//
//  NotificationListDomain.swift
//  SendNow
//
//  Created by 한소희 on 9/2/24.
//

import Foundation

enum NotificationSubject: Int {
    case friendRequest = 0
    case groupInvited = 1
    case `default` = 2
}

struct NotificationListDomain {
    let notificationID: Int
    let senderUserID: Int
    let receiverUserID: Int
    let notificationBody: String
    let isRead: Bool
    let subject: NotificationSubject
}
