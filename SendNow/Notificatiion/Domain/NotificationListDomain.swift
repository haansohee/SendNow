//
//  NotificationListDomain.swift
//  SendNow
//
//  Created by 한소희 on 9/2/24.
//

import Foundation

enum NotificationSubject: Int {
    case friendRequest
    case groupInvited
    case remittance
    case `default`
}

struct NotificationListDomain {
    let notificationID: Int
    let senderUserID: Int
    let receiverUserID: Int
    let notificationBody: String
    let isRead: Bool
    let subject: NotificationSubject
}
