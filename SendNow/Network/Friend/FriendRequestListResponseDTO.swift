//
//  FriendRequestListResponseDTO.swift
//  SendNow
//
//  Created by 한소희 on 5/7/24.
//

import Foundation

struct FriendRequestListResponseDTO: Codable {
    let fromUserID: Int
    let fromUserNickname: String
    let toUserID: Int
    let toUserNickname: String
    let isFriended: Bool
}

extension FriendRequestListResponseDTO {
    func toDomain() -> FriendRequestListDomain {
        return .init(fromUserID: fromUserID, fromUserNickname: fromUserNickname,toUserID: toUserID, toUserNickname: toUserNickname,isFriended: isFriended)
    }
}
