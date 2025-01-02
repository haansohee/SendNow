//
//  NotificationStateDomain.swift
//  SendNow
//
//  Created by 한소희 on 11/18/24.
//

import Foundation

struct NotificationStateDomain {
    let userID: Int
    let state: Bool
}

extension NotificationStateDomain {
    func toRequestDTO() -> UpdateNotificationStateRequestDTO {
        return .init(userID: userID, state: state)
    }
}
