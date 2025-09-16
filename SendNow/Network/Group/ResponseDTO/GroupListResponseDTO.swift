//
//  GroupListResponseDTO.swift
//  SendNow
//
//  Created by 한소희 on 5/21/24.
//

import Foundation

struct GroupListResponseDTO: Codable {
    let groupID: Int
    let groupName: String
    let createdDate: String
    let groupFriends: [String]
    let isActive: Bool
}
