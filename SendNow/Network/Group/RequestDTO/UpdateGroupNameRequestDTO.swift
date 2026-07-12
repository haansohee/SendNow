//
//  UpdateGroupNameRequestDTO.swift
//  SendNow
//
//  Created by 한소희 on 12/3/25.
//

import Foundation

struct UpdateGroupNameRequestDTO: Codable {
    let groupID: Int
    let groupName: String
}
