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
    let bankName: String?
    let accountNumber: String?
    let kakaoPayUrl: String?
}
