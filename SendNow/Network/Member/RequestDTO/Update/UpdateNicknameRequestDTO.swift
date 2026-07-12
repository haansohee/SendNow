//
//  UpdateNicknameRequestDTO.swift
//  SendNow
//
//  Created by 한소희 on 4/29/24.
//

import Foundation

struct UpdateNicknameRequestDTO: Codable {
    let userID: Int
    let nickname: String
}
