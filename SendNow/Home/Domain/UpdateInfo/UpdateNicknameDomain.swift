//
//  UpdateNicknameDomain.swift
//  SendNow
//
//  Created by 한소희 on 4/29/24.
//

import Foundation

struct UpdateNicknameDomain {
    let userID: Int
    let nickname: String
}

extension UpdateNicknameDomain {
    func toRequestDTO() -> UpdateNicknameRequestDTO {
        return .init(userID: userID, nickname: nickname)
    }
}
