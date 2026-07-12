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
    let groupName: String
    let groupCreatorID: Int
    let remainderUserID: Int
}

extension GroupMemberListResponseDTO {
    func toDomain() -> GroupMemberList {
        return .init(
            groupID: groupID,
            userID: userID,
            nickname: nickname,
            groupName: groupName,
            groupCreatorID: groupCreatorID,
            remainderUserID: remainderUserID
        )
    }
}
