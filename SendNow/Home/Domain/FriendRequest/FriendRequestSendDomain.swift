//
//  FriendRequestSendDomain.swift
//  SendNow
//
//  Created by 한소희 on 5/7/24.
//

import Foundation

struct FriendRequestSendDomain {
    let fromUserID: Int
    let fromUserNickname: String
    let toUserID: Int
}

extension FriendRequestSendDomain {
    func toRequestDTO() -> FriendRequestSendDTO {
        return .init(fromUserID: fromUserID, fromUserNickname: fromUserNickname, toUserID: toUserID)
    }
}
