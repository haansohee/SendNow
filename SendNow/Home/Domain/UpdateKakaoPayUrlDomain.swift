//
//  UpdateKakaoPayUrlDomain.swift
//  SendNow
//
//  Created by 한소희 on 4/29/24.
//

import Foundation

struct UpdateKakaoPayUrlDomain {
    let userID: Int
    let kakaoPayUrl: String
}

extension UpdateKakaoPayUrlDomain {
    func toRequestDTO() -> UpdateKakaoPayUrlRequestDTO {
        return .init(userID: userID, kakaoPayUrl: kakaoPayUrl)
    }
}
