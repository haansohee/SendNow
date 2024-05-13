//
//  FriendReuqestSendDTO.swift
//  SendNow
//
//  Created by 한소희 on 5/7/24.
//

import Foundation

struct FriendRequestSendDTO: Codable {
    let fromUserID: Int
    let fromUserNickname: String
    let toUserID: Int
}
