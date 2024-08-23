//
//  FriendNotificationRequestDTO.swift
//  SendNow
//
//  Created by 한소희 on 8/20/24.
//

import Foundation

struct FriendNotificationRequestDTO: Codable {
    let senderUserID: Int
    let receiverUserID: Int
}
