//
//  GroupMemberListResponseDTO.swift
//  SendNow
//
//  Created by 한소희 on 5/24/24.
//

import Foundation

struct GroupMemberListResponseDTO: Codable {
    let groupID: Int
    let userID: Int
    let nickname: String
}

extension GroupMemberListResponseDTO {
    func toDomain() -> GroupMemberListDomain {
        return .init(groupID: groupID, userID: userID, nickname: nickname)
    }
}
