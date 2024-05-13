//
//  DeleteFriendRequestDTO.swift
//  SendNow
//
//  Created by 한소희 on 5/7/24.
//

import Foundation

struct DeleteFriendRequestDTO: Codable {
    let fromUserID: Int
    let toUserID: Int
}
