//
//  SearchFriendResponseDTO.swift
//  SendNow
//
//  Created by 한소희 on 4/30/24.
//

import Foundation

struct SearchFriendResponseDTO: Codable {
    let userID: Int
    let nickname: String
    let kakaoPayUrl: String?
}

extension SearchFriendResponseDTO {
    func toDomain() -> SearchFriend {
        return .init(
            userID: userID,
            nickname: nickname,
            kakaoPayUrl: kakaoPayUrl
        )
    }
}
