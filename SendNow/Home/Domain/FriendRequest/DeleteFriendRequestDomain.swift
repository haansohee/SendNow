//
//  DeleteFriendRequestDomain.swift
//  SendNow
//
//  Created by 한소희 on 5/7/24.
//

import Foundation

struct DeleteFriendRequestDomain {
    let fromUserID: Int
    let toUserID: Int
}

extension DeleteFriendRequestDomain {
    func toRequestDTO() -> DeleteFriendRequestDTO {
        return .init(fromUserID: fromUserID, toUserID: toUserID)
    }
}
