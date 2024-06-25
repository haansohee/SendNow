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
    let searchID: String
    let bankName: String?
    let accountNumber: String?
    let kakaoPayUrl: String?
}

extension SearchFriendResponseDTO {
    func toDomain() -> SearchFriendDomain {
        return .init(userID: userID, nickname: nickname, searchID: searchID, bankName: bankName, accountNumber: accountNumber, kakaoPayUrl: kakaoPayUrl)
    }
}
