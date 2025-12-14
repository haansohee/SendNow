//
//  MyFriendListResponseDTO.swift
//  SendNow
//
//  Created by 한소희 on 5/7/24.
//

import Foundation

struct MyFriendListResponseDTO: Codable {
    let userID: Int
    let nickname: String
    let kakaoPayUrl: String?
}

extension MyFriendListResponseDTO {
    func toDomain() -> MyFriendList {
        return .init(
            userID: userID,
            nickname: nickname,
            kakaoPayUrl: kakaoPayUrl
        )
    }
}
