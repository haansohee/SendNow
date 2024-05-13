//
//  UpdateFriendStateDTO.swift
//  SendNow
//
//  Created by 한소희 on 5/7/24.
//

import Foundation

struct UpdateFriendStateDTO: Codable {
    let fromUserID: Int
    let toUserID: Int
    let isFriended: Bool
}
