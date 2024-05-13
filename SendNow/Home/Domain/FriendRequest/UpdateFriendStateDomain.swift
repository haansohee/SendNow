//
//  UpdateFriendStateDomain.swift
//  SendNow
//
//  Created by 한소희 on 5/7/24.
//

import Foundation

struct UpdateFriendStateDomain {
    let fromUserID: Int
    let toUserID: Int
    let isFriended: Bool
}

extension UpdateFriendStateDomain {
    func toRequestDTO() -> UpdateFriendStateDTO {
        return .init(fromUserID: fromUserID, toUserID: toUserID, isFriended: isFriended)
    }
}
